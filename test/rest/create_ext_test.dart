import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../models/user_model.dart';
import '../utils/mock_interceptor.dart';

void main() {
  group('Axelor Create Function', () {
    test('Success', () async {
      initAxelor('/rest/create/success_create', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName);
        expect(request.queryParameters, equals({}));
        expect(
          request.data,
          equals({
            'fields': ['name', 'lastName'],
            'data': {
              'firstName': 'John',
              'lastName': 'Smith',
              'email': 'j.smith@gmail.com',
            },
          }),
        );
      });

      final user = await Axelor.create(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        body: const AxelorBody(
          fields: ['name', 'lastName'],
          data: {
            'firstName': 'John',
            'lastName': 'Smith',
            'email': 'j.smith@gmail.com',
          },
        ),
      );

      expect(user.isSuccess, equals(true));

      expect(
        user.getOrThrow(),
        equals(const UserModel(id: 1, version: 1, email: 'j.smith@gmail.com', fullName: 'John Smith')),
      );

      Axelor.close();
    });

    test('Failure', () async {
      initAxelor('/rest/errors/failure', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName);
        expect(request.queryParameters, equals({}));
        expect(
          request.data,
          equals({
            'fields': ['name', 'lastName'],
            'data': {
              'firstName': 'John',
              'lastName': 'Smith',
              'email': 'j.smith@gmail.com',
            },
          }),
        );
      });

      final users = await Axelor.create(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        body: const AxelorBody(
          fields: ['name', 'lastName'],
          data: {
            'firstName': 'John',
            'lastName': 'Smith',
            'email': 'j.smith@gmail.com',
          },
        ),
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });

    test('Validation Error', () async {
      initAxelor('/rest/errors/validation_error', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName);
        expect(request.queryParameters, equals({}));
        expect(
          request.data,
          equals({
            'fields': ['name', 'lastName'],
            'data': {
              'firstName': 'John',
              'lastName': 'Smith',
              'email': 'j.smith@gmail.com',
            },
          }),
        );
      });

      final users = await Axelor.create(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        body: const AxelorBody(
          fields: ['name', 'lastName'],
          data: {
            'firstName': 'John',
            'lastName': 'Smith',
            'email': 'j.smith@gmail.com',
          },
        ),
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });
  });
}
