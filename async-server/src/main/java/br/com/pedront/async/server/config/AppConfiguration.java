package br.com.pedront.async.server.config;

import ma.glasnost.orika.MapperFacade;
import ma.glasnost.orika.MapperFactory;
import ma.glasnost.orika.impl.DefaultMapperFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.repository.config.EnableReactiveMongoRepositories;

@Configuration
//@EnableSwagger2
@EnableReactiveMongoRepositories("br.com.pedront.async.server.repository")
public class AppConfiguration {

//    @Bean
//    public Docket api() {
//        return new Docket(DocumentationType.SWAGGER_2)
//            .useDefaultResponseMessages(false)
//            .select()
//            .apis(RequestHandlerSelectors.any())
//            .paths(PathSelectors.any())
//            .build();
//    }

    @Bean
    public MapperFactory getMapperFactory() {
        return new DefaultMapperFactory.Builder().build();
    }

    @Bean
    public MapperFacade getMapperFacade(MapperFactory factory) {
        return factory.getMapperFacade();
    }
}
