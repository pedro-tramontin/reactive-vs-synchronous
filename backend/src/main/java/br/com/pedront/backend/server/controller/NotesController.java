package br.com.pedront.backend.server.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import java.util.UUID;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.com.pedront.server.controller.dto.NoteVO;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "notes", produces = APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class NotesController {

    @PostMapping
    public NoteVO create(@RequestBody final NoteVO note) {

        try {
            Thread.sleep(500);

            note.setId(UUID.randomUUID().toString());
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        return note;

    }

}
