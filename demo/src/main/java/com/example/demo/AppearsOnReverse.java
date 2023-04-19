package com.example.demo;

import org.springframework.data.neo4j.core.schema.*;


@RelationshipProperties
public class AppearsOnReverse {   //transitional class

    @Id
    @GeneratedValue
    private Long id;

    @Property("song_nr")  //only if it differs
    private Integer songNr;

    @TargetNode
    private Song song;

    public Integer getSongNr() {
        return songNr;
    }

    public Song getSong() {
        return song;
    }


}
