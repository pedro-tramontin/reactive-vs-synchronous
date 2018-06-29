package br.com.pedront.sync.server.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.com.pedront.server.controller.dto.NoteVO;
import br.com.pedront.sync.server.client.NotesClient;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping(path = "/notes", produces = APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class NotesController {

    private final NotesClient notesClient;

    @PostMapping
    public NoteVO create(@RequestBody final NoteVO note) {

        return notesClient.create(note);

    }

}
