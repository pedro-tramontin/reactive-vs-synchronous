package br.com.pedront.async.server.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;

import br.com.pedront.server.controller.dto.NoteVO;
import lombok.RequiredArgsConstructor;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/notes", produces = APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class NotesController {

    private final WebClient.Builder webClientBuilder;

    @Value("${BACKEND_HOST}")
    private String backendHost;

    @PostMapping
    public Mono<NoteVO> create(@RequestBody final NoteVO note) {

        return webClientBuilder.baseUrl("http://" + backendHost + ":8080")
                .build()
                .post()
                .uri("/notes")
                .contentType(APPLICATION_JSON)
                .syncBody(note)
                .retrieve()
                .bodyToMono(NoteVO.class);

    }

}
