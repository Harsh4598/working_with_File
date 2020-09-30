class Qualification {
  int id;
  String name;

  Qualification(this.id, this.name);

  static List<Qualification> getCompanies() {
    return <Qualification>[
      Qualification(1, 'Information Technology'),
      Qualification(2, 'Computer Engineer'),
      Qualification(3, 'Mechanical Engineer'),
      Qualification(4, 'Civil Engineer'),
    ];
  }
}
