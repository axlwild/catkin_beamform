/**
 * Beamform that carries out phase-based frequency masking by simple thresholding.
 * 
 * Reverberation:
 * This beamforms consider a constant reverberation level.
 * 
 * So, it needs a buffer with the dur
 * 
 * 
 */

/**
 * Versión 1. (hasta primera semana enero 2020)
 * 
 * Agregamos un buffer global que almacene el equivalente al tiempo de reverberación calculado.
 * Ejemplo: Reverberación de 0.3 segundos.
 * Agregamos buffer auxiliar del mismo tamaño que la entrada para pasar a frecuencia del buffer global
 * y poder hacer las comparaciones.
 * Vamos a poder hacer las comparaciones hasta que se llene el buffer una vez
 * 
 * */
#include "rosjack.h"
#include "util.h"

// Include FFTW header
#include <complex>
#include <fftw3.h>

// Eigen include
#include <Eigen/Eigen>

bool READY = false;
bool DELAY_BUFFER_READY = false;
// to fill delay_buffer
int  delay_current_sample = 0;
std::complex<double> *x_fft, *x_time, *y_fft, *y_time, 
    *x_time_rev, *y_time_rev, *y_fft_rev, *x_fft_rev, 
    *y_fft_aux_rev;
// Vectors with the inverse 
std::complex<double> *x_fft_delayed = nullptr, *y_fft_delayed = nullptr;
std::complex<double> *x_fft_bin = nullptr, *y_fft_bin = nullptr;
fftw_plan x_forward, y_inverse;

float  time_per_window ;
float  delay_window_secs = 0.365; //equivalent in seconds TODO: input as argument in ROS.
int    delay_window_size ; //equivalent in samples
double *bin_phases_delayed; 
double *bin_phases_delayed_aux; 
double *freqs;
double *delays;
int     idx_delay = 1;
Eigen::MatrixXcd weights;

double mag_mult = 0.0001;
double mag_threshold = 0.0001;
double min_phase = 10;
double min_phase_diff_mean = 10*M_PI/180;
float rev_threshold = 0.8;
float delay_time    = 5.0;
float time_counter  = 0;
//reused buffers
double *phases_aligned;
Eigen::MatrixXcd in_fft;

void update_weights(bool ini=false){
    calculate_delays(delays);
    
    int i,j;
    
    for(i = 0; i < array_geometry.size(); i++){
        if (i == 0){
            if(ini){
                for(j = 0; j < fft_win; j++){
                    weights(i,j) = 1.0; 
                }
            }
        }else{
            for(j = 0; j < fft_win; j++){
                weights(i,j) = std::exp(-M_I*(double)2*PI*freqs[j]*delays[i]); 
            }
        }
    }
}

double get_overall_phase_diff(int min_i,int *num_i){
    if (min_i < number_of_microphones-1){
        double this_diff = 0;
        double this_diff_raw;
        for (int i = min_i+1; i < number_of_microphones; i++){
            this_diff_raw = abs(phases_aligned[min_i]-phases_aligned[i]);
            if (this_diff_raw > M_PI)
                this_diff_raw = 2*M_PI - this_diff_raw;
            this_diff += this_diff_raw;
            (*num_i)++;
        }
        return this_diff + get_overall_phase_diff(min_i+1,num_i);
    }else{
        return 0;
    }
}

void apply_weights (jack_ringbuffer_t **in, rosjack_data *out){
    int i,j;
    double phase_diff_sum;
    int phase_diff_num;
    double phase_diff_mean;
    double mag_mean;
    double pha_mean;
    
    // fft
    for(i = 0; i < number_of_microphones; i++){
        overlap_and_add_prepare_input(in[i], x_time);
        fftw_execute(x_forward);
        for(j = 0; j < fft_win; j++){
            in_fft(i,j) = x_fft[j];
        }
    }
    // Counting time 
    // if (time_counter < delay_time){ time_counter += time_per_window; }
    // else { time_counter = time_counter - delay_time + time_per_window; }
    
    y_fft[0] = in_fft(0,0);

    bool freq_delayed ;
    for(j = 1; j < fft_win; j++){
        //creating new frequency data bin from mean magnitude
        mag_mean = 0;
        for(i = 0; i < number_of_microphones; i++){
            mag_mean += abs(in_fft(i,j));
        }
        mag_mean /= number_of_microphones;
        
        //and getting the phase of the reference microphone
        pha_mean = arg(in_fft(0,j));
        phase_diff_mean = 0;
        freq_delayed = false;
        if (mag_mean/fft_win > mag_threshold){
          //applying weights to align phases
          for(i = 0; i < number_of_microphones; i++){
            phases_aligned[i] = arg(conj(weights(i,j))*in_fft(i,j));
          }
          
          //getting the mean phase difference between all microphones
          phase_diff_num = 0;
          phase_diff_sum = get_overall_phase_diff(0,&phase_diff_num);
          phase_diff_mean = phase_diff_sum/(double)phase_diff_num;
          // TODO: Responder: ¿calcular este pha_mean hace alguna distinción con el de arriba?
          pha_mean = arg(in_fft(0,j));

          if (phase_diff_mean < min_phase_diff_mean){
            freq_delayed = true;
            if(DELAY_BUFFER_READY && (bin_phases_delayed_aux[j] == true)  
                //&& (bin_phases_delayed_aux[j] < phase_diff_mean ) 
                )
            {
                mag_mean *= mag_mult;    
                //std::cout << "|" << std::endl;
            }
            else{
                //std::cout << ":";
            }
            y_fft[j] = std::complex<double>(mag_mean*cos(pha_mean),mag_mean*sin(pha_mean));
          }else{
              //std::cout << "!" << std::endl;
              mag_mean *= mag_mult;
              y_fft[j] = std::complex<double>(mag_mean*cos(pha_mean),mag_mean*sin(pha_mean));
              // update to know if a phase is not taken as a valid frequency in delay frequencies.
              phase_diff_mean = 0;
          }
        }
        else{
            // std::cout << "|" << mag_mean/fft_win << "| vs |" << mag_threshold << "|" << std::endl;
            mag_mean *= mag_mult;
            y_fft[j] = std::complex<double>(mag_mean*cos(pha_mean),mag_mean*sin(pha_mean));
        }
        if (idx_delay >= delay_window_size ){
            DELAY_BUFFER_READY = true; 
            idx_delay = 1;
        }
        // means of phases delayed
        bin_phases_delayed[idx_delay++] = freq_delayed;
        y_fft_delayed[idx_delay++] = std::complex<double>(mag_mean*cos(pha_mean),mag_mean*sin(pha_mean));
        //mag_mean *= 1 / (1+(15.0)*phase_diff_mean); // 15.0 here is a constant that is linked to the minimum phase difference
        //y_fft[j] = std::complex<double>(mag_mean*cos(pha_mean),mag_mean*sin(pha_mean));
    }
    
    int idx_aux = 0;
    if (DELAY_BUFFER_READY){   
        // obtenemos la transformada inversa de la info guardada en el delay.
        // usamos un buffer auxiliar de tamaño fft_win para hacer las comparaciones
        // de energía de cada frecuencia en el desfase.
        for(j = 1; j < fft_win; j++){
            idx_aux = idx_delay - j;
            if(idx_aux < 0)
                idx_aux = delay_window_size + idx_aux;
            y_fft_aux_rev[fft_win - j]      = y_fft_delayed[idx_aux];
            bin_phases_delayed_aux[fft_win - j] = bin_phases_delayed[idx_aux];
        }
    }
    // ifft
    fftw_execute(y_inverse);
    
    // preparing output
    overlap_and_add_prepare_output(y_time,out);
}

int jack_callback (jack_nframes_t nframes, void *arg){
    //TimeVar t_bef = timeNow();
    int i,j;
    
    //Inputing from ROS
    rosjack_data out[nframes];
    if(READY){
        rosjack_data **in = input_from_rosjack (nframes);
        do_overlap(in, out, nframes, apply_weights);
    }else{
        for (i = 0; i < nframes; i++){
            out[i] = 0.0;
        }
    }
    
    //Outputing to ROS
    output_to_rosjack (out, nframes, output_type);
    
    //std::cout << "Callback took: " << duration(timeNow()-t_bef)/1000000.0 << " ms.\n";
    return 0;
}

void theta_roscallback(const std_msgs::Float32::ConstPtr& msg){
    ROS_INFO("Updating weights for angle: %f", msg->data);
    
    angle = msg->data;
    update_weights();
}

void phase_handle_params(ros::NodeHandle *n){
    std::string node_name = ros::this_node::getName();
    std::cout << "Phase rev ROS parameters: " << std::endl;
    
    if ((*n).getParam(node_name+"/min_phase",min_phase)){
        ROS_INFO("Min Phase Threshold: %f",min_phase);
    }else{
        min_phase = 10.0;
        ROS_WARN("Min Phase Threshold argument not found in ROS param server, using default value (%f).",min_phase);
    }
    min_phase_diff_mean = min_phase*M_PI/180;
    
    if ((*n).getParam(node_name+"/mag_mult",mag_mult)){
        ROS_INFO("Mag Multiplier: %f",mag_mult);
    }else{
        mag_mult = 0.1;
        ROS_WARN("Mag Multiplier argument not found in ROS param server, using default value (%f).",mag_mult);
    }
    
    if ((*n).getParam(node_name+"/mag_threshold",mag_threshold)){
        ROS_INFO("Mag Threshold: %f",mag_threshold);
    }else{
        mag_threshold = 0.05;
        ROS_WARN("Mag Threshold argument not found in ROS param server, using default value (%f).",mag_threshold);
    }

    if ((*n).getParam(node_name+"/delay_time",delay_time)){
        ROS_INFO("Calculated reverb time: %f",delay_time);
    }else{
        delay_time = 5.0;
        ROS_WARN("Reverb time argument not found in ROS param server, using default value (%f).",delay_time);
    }
}

int main (int argc, char *argv[]) {
    int i;
    /* ROS initialization*/
    ros::init(argc, argv, client_name);
    ros::NodeHandle n;
    handle_params(&n);
    phase_handle_params(&n);
    
    ros::Subscriber theta_subscriber = n.subscribe("theta", 1000, theta_roscallback);
    
    
    /* create JACK agent */
    if(rosjack_create (ROSJACK_READ, &n, "jackaudio", client_name, number_of_microphones, jack_callback)){
        ROS_ERROR("JACK agent could not be created.\n");
        ros::shutdown();
        exit(1);
    }
    int sample_rate = jack_get_sample_rate (jack_client);
    // jack_client defined in rosjack.h
    prepare_overlap_and_add(); //fft_win is assinged here
    printf ("Sample rate: %d\n", sample_rate);
    time_per_window   = (float)fft_win / (float)sample_rate;
    delay_window_size =  (int)(delay_window_secs * sample_rate);
    std::cout << "Delay window size: " << delay_window_size  << std::endl;
    std::cout << "window size: " << fft_win  << std::endl;
    std::cout << number_of_microphones  << " mics detected " << std::endl;
    std::cout << "Pre-allocating space for internal buffers." << std::endl;
    
    x_fft = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    x_time = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    y_fft = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    y_time = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    // x_time_rev = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * delay_window_size);
    // y_time_rev = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * delay_window_size);
    // x_fft_rev = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * delay_window_size);
    // y_fft_rev = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * delay_window_size);
    
    
    // recuerda que fft_win es el tamaño de la ventana
    // x_fft_delayed = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    y_fft_delayed = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * delay_window_size);
    y_fft_aux_rev = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    // binary selection
    x_fft_bin = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    y_fft_bin = (std::complex<double>*) fftw_malloc(sizeof(std::complex<double>) * fft_win);
    

    x_forward = fftw_plan_dft_1d(fft_win, reinterpret_cast<fftw_complex*>(x_time), reinterpret_cast<fftw_complex*>(x_fft), FFTW_FORWARD, FFTW_MEASURE);
    y_inverse = fftw_plan_dft_1d(fft_win, reinterpret_cast<fftw_complex*>(y_fft), reinterpret_cast<fftw_complex*>(y_time), FFTW_BACKWARD, FFTW_MEASURE);
    // x_forward_rev = fftw_plan_dft_1d(delay_window_size, reinterpret_cast<fftw_complex*>(x_time_rev), reinterpret_cast<fftw_complex*>(x_fft_rev), FFTW_FORWARD, FFTW_MEASURE);
    // y_inverse_rev = fftw_plan_dft_1d(delay_window_size, reinterpret_cast<fftw_complex*>(y_fft_rev), reinterpret_cast<fftw_complex*>(y_time_rev), FFTW_BACKWARD, FFTW_MEASURE);
    bin_phases_delayed = (double*) malloc(delay_window_size*sizeof(double));
    bin_phases_delayed_aux = (double*) malloc(fft_win*sizeof(double));
    freqs = (double *)malloc(sizeof(double)*fft_win);
    calculate_frequency_vector(freqs,fft_win);
    
    delays = (double *) malloc (sizeof(double)*number_of_microphones);
    phases_aligned = (double *) malloc (sizeof(double)*number_of_microphones);
    
    weights.resize(number_of_microphones,fft_win);
    in_fft.resize(number_of_microphones,fft_win);
    
    update_weights(true);
    
    READY = true;
    
    ROS_INFO("Beamform ROS node started.");
    
    /* keep running until stopped by the user */
    ros::spin();
    
    /* apparently ROS requires the use of exit, instead of return for final cleaning up */
    exit(0);
}
