package br.com.pedront.async.server.controller;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import br.com.pedront.async.server.controller.dto.NoteVO;
import br.com.pedront.async.server.entity.NotesDocument;
import br.com.pedront.async.server.repository.NotesRepository;
import lombok.RequiredArgsConstructor;
import ma.glasnost.orika.MapperFacade;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "notes", produces = APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class NotesController {

    private final NotesRepository notesRepository;

    private final MapperFacade mapper;

    @PostMapping
    public Mono<NoteVO> create(@RequestBody final NoteVO note) {

        NotesDocument entity = mapper.map(note, NotesDocument.class);

        return notesRepository.save(entity)
            .map(n -> mapper.map(n, NoteVO.class));
    }

}
