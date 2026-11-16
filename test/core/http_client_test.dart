import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:gestor_cafeteria/core/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('ApiClient', () {
    test('1. Éxito: GET 200 devuelve el JSON decodificado', () async {
      final mock = MockClient((request) async {
        return http.Response('[{"id": 1, "customer": "Ana"}]', 200);
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      final resultado = await api.get('/orders');

      expect(resultado, isA<List>());
      expect((resultado as List).first['customer'], 'Ana');
    });

    test('2. No encontrado: 404 lanza NotFoundFailure con detail', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'detail': 'Order 9 not found'}),
          404,
        );
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      await expectLater(
        api.get('/orders/9'),
        throwsA(
          isA<NotFoundFailure>().having(
            (f) => f.message,
            'message',
            'Order 9 not found',
          ),
        ),
      );
    });

    test('3. Conflicto: 409 lanza ConflictFailure con detail', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({'detail': 'Cannot change status from pending to delivered'}),
          409,
        );
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      await expectLater(
        api.patch('/orders/1', {'status': 'delivered'}),
        throwsA(
          isA<ConflictFailure>().having(
            (f) => f.message,
            'message',
            'Cannot change status from pending to delivered',
          ),
        ),
      );
    });

    test('4. Validación: 422 lanza ValidationFailure con mapa de campos', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'detail': [
              {
                'loc': ['body', 'customer'],
                'msg': 'Must be 1-50 characters',
              },
            ],
          }),
          422,
        );
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      await expectLater(
        api.post('/orders', {'customer': '', 'drink': 'latte', 'size': 'M'}),
        throwsA(
          isA<ValidationFailure>().having(
            (f) => f.fields,
            'fields',
            {'customer': 'Must be 1-50 characters'},
          ),
        ),
      );
    });

    test('5. Servidor: 503 lanza ServerFailure con statusCode 503', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode({'detail': 'Simulated failure'}), 503);
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      await expectLater(
        api.get('/orders'),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 503),
        ),
      );
    });

    test('6. Sin conexión: ClientException lanza NetworkFailure', () async {
      final mock = MockClient((request) async {
        throw http.ClientException('sin red');
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      await expectLater(
        api.get('/orders'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('6b. Tiempo agotado: exceder timeout lanza NetworkFailure', () async {
      final mock = MockClient((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 120));
        return http.Response('[]', 200);
      });
      final api = ApiClient(
        client: mock,
        baseUrl: 'http://prueba',
        timeout: const Duration(milliseconds: 50),
      );

      await expectLater(
        api.get('/orders'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('7. Defecto D3: respuesta 300 lanza UnexpectedFailure', () async {
      final mock = MockClient((request) async {
        return http.Response('', 300);
      });
      final api = ApiClient(client: mock, baseUrl: 'http://prueba');

      await expectLater(
        api.get('/orders'),
        throwsA(
          isA<UnexpectedFailure>().having(
            (f) => f.statusCode,
            'statusCode',
            300,
          ),
        ),
      );
    });
  });
}
