package br.com.pedront.sync.server.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import br.com.pedront.sync.server.controller.dto.NoteVO;
import br.com.pedront.sync.server.repository.NotesRepository;
import br.com.pedront.sync.server.entity.NotesDocument;
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

    private final NotesRepository notesRepository;

    private final MapperFacade mapper;

    @PostMapping
    public NoteVO create(@RequestBody final NoteVO note) {

        NotesDocument entity = mapper.map(note, NotesDocument.class);

        return mapper.map(notesRepository.save(entity), NoteVO.class);

    }

}
