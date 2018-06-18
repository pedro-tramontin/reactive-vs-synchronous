package br.com.pedront.sync.server;

import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

import br.com.pedront.sync.server.dto.NoteVO;
import br.com.pedront.sync.server.entity.NotesEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "notes", produces = APPLICATION_JSON_VALUE)
@RequiredArgsConstructor
public class NotesController {

    private final NotesRepository notesRepository;

    @PostMapping
    public NoteVO create(NoteVO note) {

        NotesEntity entity = new NotesEntity();
        entity.setDescription(note.getDescription());

        NotesEntity saved = notesRepository.save(entity);

        NoteVO response = new NoteVO();
        response.setDescription(saved.getDescription());

        return response;
    }

}
