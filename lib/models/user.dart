class MyUser {
  String nickname;

  MyUser({
    required this.nickname,
  });

  MyUser.fromJson(Map<String, Object?> json)
      : this(
          nickname: json['nickname'] as String,
        );

  MyUser copyWith({
    String? nickname,
  }) {
    return MyUser(nickname: nickname ?? this.nickname);
  }

  Map<String, Object?> toJson() {
    return {
      'nickname': nickname,
    };
  }
}
