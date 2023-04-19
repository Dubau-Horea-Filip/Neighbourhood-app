package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.List;

@SpringBootApplication
public class GraphProjectApplication implements CommandLineRunner {

	private final SongRepo songRepo;
	private final RealeseRepo realeseRepo;

	public GraphProjectApplication(SongRepo repo, RealeseRepo realeseRepo) {
		this.songRepo = repo;
		this.realeseRepo = realeseRepo;
	}

	public static void main(String[] args) {
		SpringApplication.run(GraphProjectApplication.class, args);
	}

	@Override
	public void run(String... args) throws Exception {

        Song s = new Song();
        AppearsOn ap = new AppearsOn();
        AppearsOnReverse apr = new AppearsOnReverse();
        Release r = new Release();
        r.setName("ana");
        r.setYear(2022);
        r.setAppearsOnReverses(List.of(apr));
        ap.setRelease(r);  
        s.setReleses(List.of());
        songRepo.save(s);

		for(Song song: songRepo.findAll())
		{
			System.out.println(song.getName());
			for(AppearsOn ao: song.getReleses())
				System.out.println("  "+ ao.getSongNr() + " " + ao.getRelease().getName());
		}
		for(Release release: realeseRepo.findAll())
		{
			System.out.println(release.getName());
			for(AppearsOnReverse aor: release.getAppearsOnReverses())
				System.out.println("  "+ aor.getSongNr() + " " + aor.getSong().getName());
		}
	}
}
