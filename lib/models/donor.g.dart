// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Donor _$DonorFromJson(Map<String, dynamic> json) => Donor(
      nome: json['nome'] as String,
      cpf: json['cpf'] as String,
      rg: json['rg'] as String?,
      dataNasc: json['data_nasc'] as String,
      sexo: json['sexo'] as String,
      altura: (json['altura'] as num).toDouble(),
      peso: (json['peso'] as num).toDouble(),
      tipoSanguineo: json['tipo_sanguineo'] as String,
    );

Map<String, dynamic> _$DonorToJson(Donor instance) => <String, dynamic>{
      'nome': instance.nome,
      'cpf': instance.cpf,
      'rg': instance.rg,
      'data_nasc': instance.dataNasc,
      'sexo': instance.sexo,
      'altura': instance.altura,
      'peso': instance.peso,
      'tipo_sanguineo': instance.tipoSanguineo,
    };
