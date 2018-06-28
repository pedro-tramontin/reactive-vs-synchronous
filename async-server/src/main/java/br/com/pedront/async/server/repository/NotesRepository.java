package br.com.pedront.async.server.repository;

import br.com.pedront.async.server.entity.NotesDocument;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;

public interface NotesRepository extends ReactiveCrudRepository<NotesDocument, String> {

}
