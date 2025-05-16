import 'package:json_annotation/json_annotation.dart';

part 'donor.g.dart';

@JsonSerializable()
class Donor {
  final String nome;
  final String cpf;
  final String? rg;
  @JsonKey(name: 'data_nasc')
  final String dataNasc;
  final String sexo;
  final double altura;
  final double peso;
  @JsonKey(name: 'tipo_sanguineo')
  final String tipoSanguineo;

  Donor({
    required this.nome,
    required this.cpf,
    this.rg,
    required this.dataNasc,
    required this.sexo,
    required this.altura,
    required this.peso,
    required this.tipoSanguineo,
  });

  factory Donor.fromJson(Map<String, dynamic> json) => _$DonorFromJson(json);
  Map<String, dynamic> toJson() => _$DonorToJson(this);
}
