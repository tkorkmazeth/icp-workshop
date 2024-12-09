import Nat32 "mo:base/Nat32";
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import List "mo:base/List";
import Text "mo:base/Text";
import Result "mo:base/Result";


actor SuperHeros {

  public type SuperHeroId = Nat32;

  public type SuperHero = {
    name: Text;
    superpowers: List.List<Text>;
  };

  private stable var next: SuperHeroId = 0;
  private stable var superheroes : Trie.Trie<SuperHeroId, SuperHero> = Trie.empty();

  public func create(superHero: SuperHero): async SuperHeroId {
    let superHeroId = next;
    next += 1;

    superheroes := Trie.replace(
      superheroes,
      key(superHeroId),
      Nat32.equal,
      ?superHero,
    ).0;

    superHeroId
  };

  public query func getHero(id: SuperHeroId): async ?SuperHero {
    let result = Trie.find(
      superheroes,
      key(id),
      Nat32.equal
      );

      return result;
  };

  public func update(id: SuperHeroId, newHero: SuperHero): async Bool {
    let result = Trie.find(superheroes, key(id), Nat32.equal);
    let exists = Option.isSome(result);

    if(exists){
      superheroes := Trie.replace(
        superheroes,
        key(id),
        Nat32.equal,
        ?newHero,
      ).0;

    };

    exists
  };

  private func key(x: SuperHeroId): Trie.Key<SuperHeroId> {
    { hash = x; key = x };
  };

}
