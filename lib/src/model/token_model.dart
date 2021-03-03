TokenResponseModel tokenResponseModelFromJson(dynamic str) =>
    TokenResponseModel.fromJson(str);

class TokenResponseModel {
  TokenResponseModel({
    this.response,
    this.metadata,
  });

  Response response;
  Metadata metadata;

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      TokenResponseModel(
        response: Response.fromJson(json["response"]),
        metadata: Metadata.fromJson(json["metadata"]),
      );
}

class Metadata {
  Metadata({
    this.message,
    this.code,
  });

  String message;
  int code;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        message: json["message"],
        code: json["code"],
      );
}

class Response {
  Response({
    this.token,
  });

  String token;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        token: json["token"],
      );
}
