package br.com.pedront.sync.server.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "notes")
public class NotesDocument {

    @Id
    private String id;

    private String description;

}
