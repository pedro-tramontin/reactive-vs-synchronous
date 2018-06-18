package br.com.pedront.sync.server;

import br.com.pedront.sync.server.entity.NotesEntity;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface NotesRepository extends MongoRepository<NotesEntity, String> {

}
