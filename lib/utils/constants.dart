final RegExp emailReg = RegExp('^[a-zA-Z0-9.-_+]+@[a-zA-Z.-_+].[a-zA-Z]{2,}');
final RegExp passwordReg =
    RegExp(r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$");

final RegExp nameReg = RegExp(r"\b([A-ZÀ-ÿ][-,a-z. ']+[ ]*)+");

const String placeholderPfp =
    "https://t3.ftcdn.net/jpg/05/16/27/58/360_F_516275801_f3Fsp17x6HQK0xQgDQEELoTuERO4SsWV.jpg";
const String pfpAsset = "assets/pfp.jpg";
