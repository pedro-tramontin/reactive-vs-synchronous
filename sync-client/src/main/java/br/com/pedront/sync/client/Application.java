package br.com.pedront.sync.client;

import br.com.pedront.sync.client.feign.SyncServer;
import br.com.pedront.sync.server.controller.dto.NoteVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
@EnableFeignClients
public class Application {

    @Autowired
    private SyncServer syncServer;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner(ApplicationContext ctx) {
        return args -> {

            NoteVO note = new NoteVO();

            System.out.println(syncServer.create(note));

        };
    }

}