package br.com.pedront.sync.server.client;

import br.com.pedront.async.server.controller.dto.NoteVO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "notes-client", url = "http://${BACKEND_HOST}:8080")
public interface NotesClient {

    @PostMapping
    NoteVO create(NoteVO noteVO);

}
