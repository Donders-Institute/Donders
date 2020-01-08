// threads
udp_Threads hilo_send,hilo_recv;

void setup(){

    hilo_send = new udp_Threads(1000,"send");
    hilo_send.port = 5001;
    hilo_send.ip = "192.168.1.13";            // ip of the IoT
    hilo_send.start();
    
    hilo_recv = new udp_Threads(50,"recv"); // ip of the IoT
    hilo_recv.port = 4001;
    hilo_recv.ip = "192.168.1.13";
    hilo_recv.start();

}


void draw(){
  

}
