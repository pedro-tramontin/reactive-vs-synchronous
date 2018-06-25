package br.com.pedront.sync.client.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;

import br.com.pedront.sync.server.controller.dto.NoteVO;

@FeignClient(name = "sync-server-rest-api", url = "http://35.192.146.150:8080/")
public interface SyncServer {

    @PostMapping("/notes")
    NoteVO create(NoteVO note);

}
