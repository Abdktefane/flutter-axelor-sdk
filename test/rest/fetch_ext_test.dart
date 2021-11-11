import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_criteria.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../models/user_model.dart';
import '../utils/fixture_reader.dart';
import '../utils/mock_interceptor.dart';

void main() {
  group('Basic Axelor Fetch Function', () {
    test('Success', () async {
      initAxelor('/rest/fetch/success_fetch', requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('GET'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(request.queryParameters, {});
      });

      final user = await Axelor.fetch(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
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
        expect(request.data, isNull);
        expect(request.method, equals('GET'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(
          request.queryParameters,
          equals({}),
        );
      });

      final users = await Axelor.fetch(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });

    test('Validation Error', () async {
      initAxelor('/rest/errors/validation_error', requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('GET'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(request.queryParameters, equals({}));
      });

      final users = await Axelor.fetch(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });
  });

  group('Advanced Axelor Fetch Function', () {
    test('Success', () async {
      initAxelor('/rest/fetch/success_fetch', requestChecker: (request) {
        expect(request.data, equals(FixtureReader.readJson('/rest/fetch/advance_fetch_body')));
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1' + '/${AxelorApiAction.fetch.row}',
        );
        expect(request.queryParameters, {});
      });

      final user = await Axelor.fetch(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
        body: AxelorBody(
          translate: true,
          archived: true,
          sortBy: const ['fullName', '-createdOn'],
          fields: const ['fullName', 'email'],
          domainContext: const {'email': '%gmail.com'},
          domain: 'self.email like :email',
          related: const [
            MapEntry('user', ['name', 'email']),
            MapEntry('parent', ['fullName']),
          ],
          criteria: AxelorCriteria.and([
            'email'.like('%gmail.com'),
            'lang'.equal('FR'),
            'age'.between('18', '40'),
            AxelorCriteria.or(['firstName'.notLike('j%')]),
            AxelorCriteria.not([
              'age'.inValues(['18', '21', '22']),
            ]),
          ]),
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
      initAxelor('/rest/errors/failure', pageSize: 8, requestChecker: (request) {
        expect(request.data, equals(FixtureReader.readJson('/rest/fetch/advance_fetch_body')));
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1' + '/${AxelorApiAction.fetch.row}',
        );
        expect(request.queryParameters, {});
      });

      final users = await Axelor.fetch(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
        body: AxelorBody(
          translate: true,
          archived: true,
          sortBy: const ['fullName', '-createdOn'],
          fields: const ['fullName', 'email'],
          domainContext: const {'email': '%gmail.com'},
          domain: 'self.email like :email',
          related: const [
            MapEntry('user', ['name', 'email']),
            MapEntry('parent', ['fullName']),
          ],
          criteria: AxelorCriteria.and([
            'email'.like('%gmail.com'),
            'lang'.equal('FR'),
            'age'.between('18', '40'),
            AxelorCriteria.or(['firstName'.notLike('j%')]),
            AxelorCriteria.not([
              'age'.inValues(['18', '21', '22']),
            ]),
          ]),
        ),
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });

    test('Validation Error', () async {
      initAxelor('/rest/errors/validation_error', pageSize: 8, requestChecker: (request) {
        expect(request.data, equals(FixtureReader.readJson('/rest/fetch/advance_fetch_body')));
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1' + '/${AxelorApiAction.fetch.row}',
        );
        expect(request.queryParameters, {});
      });

      final users = await Axelor.fetch(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        id: 1,
        body: AxelorBody(
          translate: true,
          archived: true,
          sortBy: const ['fullName', '-createdOn'],
          fields: const ['fullName', 'email'],
          domainContext: const {'email': '%gmail.com'},
          domain: 'self.email like :email',
          related: const [
            MapEntry('user', ['name', 'email']),
            MapEntry('parent', ['fullName']),
          ],
          criteria: AxelorCriteria.and([
            'email'.like('%gmail.com'),
            'lang'.equal('FR'),
            'age'.between('18', '40'),
            AxelorCriteria.or(['firstName'.notLike('j%')]),
            AxelorCriteria.not([
              'age'.inValues(['18', '21', '22']),
            ]),
          ]),
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
