package com.example.demo;

import org.springframework.data.neo4j.core.schema.*;


@RelationshipProperties
public class AppearsOn {   //transitional class

    @Property("song_nr")  //only if it differs
    private Integer songNr;

    @Id
    @GeneratedValue
    private Long id;

    @TargetNode
    private Release release;

    public Integer getSongNr() {
        return songNr;
    }

    public Release getRelease() {
        return release;
    }

    public void setRelease(Release release) {
        this.release = release;
    }
}
