package br.com.pedront.sync.server.config;

import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableFeignClients("br.com.pedront.sync.server.client")
public class AppConfiguration {

}