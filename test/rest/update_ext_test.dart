import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../models/user_model.dart';
import '../utils/mock_interceptor.dart';

void main() {
  group('Axelor Update Function', () {
    test('Success with version passed', () async {
      initAxelor('/rest/update/success_update', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(request.queryParameters, equals({}));
        expect(
          request.data,
          equals({
            'fields': ['name', 'lastName'],
            'data': {
              'id': 1,
              'version': 1,
              'firstName': 'John',
              'lastName': 'Smith',
              'email': 'j.smith@gmail.com',
            },
          }),
        );
      });

      final user = await Axelor.update(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
        version: 1,
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
        equals(const UserModel(id: 1, version: 2, email: 'j.smith@gmail.com', fullName: 'John Smith')),
      );

      Axelor.close();
    });

    test('Success with no version passed', () async {
      initAxelor(
        '/rest/update/version_response',
        path2: '/rest/update/success_update',
        requestChecker: (request) {
          expect(request.method, equals('POST'));
          expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1/fetch');
          expect(request.queryParameters, equals({}));
          expect(request.data, isNotNull);
          expect(
            request.data,
            equals({
              'fields': ['version'],
              'data': {}
            }),
          );
        },
        requestChecker2: (request) {
          expect(request.data, isNotNull);
          expect(request.method, equals('POST'));
          expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
          expect(request.queryParameters, equals({}));
          expect(
            request.data,
            equals({
              'fields': ['name', 'lastName'],
              'data': {
                'id': 1,
                'version': 1,
                'firstName': 'John',
                'lastName': 'Smith',
                'email': 'j.smith@gmail.com',
              },
            }),
          );
        },
      );

      final user = await Axelor.update(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
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
        equals(const UserModel(id: 1, version: 2, email: 'j.smith@gmail.com', fullName: 'John Smith')),
      );

      Axelor.close();
    });

    test('Failure', () async {
      initAxelor(
        '/rest/update/version_response',
        path2: '/rest/errors/failure',
        requestChecker: (request) {
          expect(request.method, equals('POST'));
          expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1/fetch');
          expect(request.queryParameters, equals({}));
          expect(request.data, isNotNull);
          expect(
            request.data,
            equals({
              'fields': ['version'],
              'data': {}
            }),
          );
        },
        requestChecker2: (request) {
          expect(request.data, isNotNull);
          expect(request.method, equals('POST'));
          expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
          expect(request.queryParameters, equals({}));
          expect(
            request.data,
            equals({
              'fields': ['name', 'lastName'],
              'data': {
                'id': 1,
                'version': 1,
                'firstName': 'John',
                'lastName': 'Smith',
                'email': 'j.smith@gmail.com',
              },
            }),
          );
        },
      );

      final users = await Axelor.update(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
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
      initAxelor(
        '/rest/update/version_response',
        path2: '/rest/errors/validation_error',
        requestChecker: (request) {
          expect(request.method, equals('POST'));
          expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1/fetch');
          expect(request.queryParameters, equals({}));
          expect(request.data, isNotNull);
          expect(
            request.data,
            equals({
              'fields': ['version'],
              'data': {}
            }),
          );
        },
        requestChecker2: (request) {
          expect(request.data, isNotNull);
          expect(request.method, equals('POST'));
          expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
          expect(request.queryParameters, equals({}));
          expect(
            request.data,
            equals({
              'fields': ['name', 'lastName'],
              'data': {
                'id': 1,
                'version': 1,
                'firstName': 'John',
                'lastName': 'Smith',
                'email': 'j.smith@gmail.com',
              },
            }),
          );
        },
      );

      final users = await Axelor.update(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
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
