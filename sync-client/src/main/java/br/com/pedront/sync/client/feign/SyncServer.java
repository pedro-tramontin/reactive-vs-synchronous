package br.com.pedront.sync.client.feign;

import br.com.pedront.sync.server.controller.dto.NoteVO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name = "sync-server-rest-api", url = "http://localhost:8080/")
public interface SyncServer {

    @PostMapping("/notes")
    NoteVO create(NoteVO note);

}
