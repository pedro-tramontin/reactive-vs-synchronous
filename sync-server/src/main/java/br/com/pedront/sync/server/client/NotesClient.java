package br.com.pedront.sync.server.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

import br.com.pedront.server.controller.dto.NoteVO;

@FeignClient(name = "http://${BACKEND_HOST}:8080", url = "http://${BACKEND_HOST}:8080")
public interface NotesClient {

    @PostMapping(path = "/notes")
    NoteVO create(NoteVO noteVO);

}
