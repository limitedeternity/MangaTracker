let mangaJSON = null;
void async function() {
  const res = await fetch("https://www.mangaeden.com/api/list/0/");
  mangaJSON = await res.json();
};

const searchManga = async title => {
  return mangaJSON.manga.filter(entry => entry.t.includes(title));
};

const getLatestChapterNumber = async mangaObject => {
  const res = await fetch(
    `https://www.mangaeden.com/api/manga/${mangaObject[0].i}`
  );

  const json = await res.json();
  return json.chapters[0][0];
};
