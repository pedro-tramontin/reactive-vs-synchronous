package br.com.pedront.sync.server.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import br.com.pedront.async.server.controller.dto.NoteVO;
import br.com.pedront.sync.server.client.NotesClient;
import lombok.RequiredArgsConstructor;
import ma.glasnost.orika.MapperFacade;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "notes", produces = APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class NotesController {

    private final NotesClient notesClient;

    private final MapperFacade mapper;

    @PostMapping
    public NoteVO create(@RequestBody final NoteVO note) {

        return notesClient.create(note);

    }

}
