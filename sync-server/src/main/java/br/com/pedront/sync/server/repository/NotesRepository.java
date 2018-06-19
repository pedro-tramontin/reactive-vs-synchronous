package br.com.pedront.sync.server.repository;

import br.com.pedront.sync.server.entity.NotesDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NotesRepository extends MongoRepository<NotesDocument, String> {

}
