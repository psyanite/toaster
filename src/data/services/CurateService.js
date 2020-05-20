import { Tag } from '../models';

const Tags = [
  "sweet",
  "bubble",
  "cheap",
  "fancy",
  "coffee",
  "brunch",
];

let LastRefreshed = null;
let Curates = new Map();

const fetch = (tag) => {
  return Tag.findOne({ where: { name: tag }});
};

const refresh = async () => {
  LastRefreshed = new Date();

  const promises = Tags.map((t) => fetch(t));
  const tags = await Promise.all(promises);

  tags.forEach((t) => {
    Curates.set(t.name, t)
  });
};

refresh();

export default class FeedService {

  static getCurate(tag) {
    if (LastRefreshed < new Date(new Date() - 60*60000)) refresh();
    return Curates.get(tag);
  }
}
