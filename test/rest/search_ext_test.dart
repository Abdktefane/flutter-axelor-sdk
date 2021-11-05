import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_criteria.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../models/user_model.dart';
import '../utils/fixture_reader.dart';
import '../utils/mock_interceptor.dart';

void main() {
  group('Basic Axelor Search Function', () {
    test('Success', () async {
      initAxelor('/rest/search/success_search', pageSize: 8, requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('GET'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName);
        expect(
          request.queryParameters,
          equals({
            'offset': 0,
            'limit': 8,
          }),
        );
      });

      final users = await Axelor.search(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        page: 0,
      );

      expect(users.isSuccess, equals(true));
      expect(users.getOrThrow().errors, isNull);

      expect(users.getOrThrow().status, equals(0));
      expect(users.getOrThrow().isEmpty, equals(false));
      expect(users.getOrThrow().nextPage, equals(1));
      expect(users.getOrThrow().page, equals(0));
      expect(users.getOrThrow().total, equals(100));
      expect(users.getOrThrow().canLoadMore, true);
      expect(users.getOrThrow().haveData, equals(true));

      expect(users.getOrThrow().data?.length, equals(8));

      expect(
        users.getOrThrow().data?.first,
        equals(const UserModel(id: 1, version: 1, email: 'j.smith@gmail.com', fullName: 'John Smith')),
      );

      expect(
        users.getOrThrow().data?.last,
        equals(const UserModel(id: 15, version: 0, email: 'tom.boy15@gmail.com', fullName: 'Tom Boy 15')),
      );

      Axelor.close();
    });

    test('Failure', () async {
      initAxelor('/rest/errors/failure', pageSize: 8, requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('GET'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName);
        expect(
          request.queryParameters,
          equals({
            'offset': 0,
            'limit': 8,
          }),
        );
      });

      final users = await Axelor.search(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        page: 0,
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });

    test('Validation Error', () async {
      initAxelor('/rest/errors/validation_error', pageSize: 8, requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('GET'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName);
        expect(
          request.queryParameters,
          equals({
            'offset': 0,
            'limit': 8,
          }),
        );
      });

      final users = await Axelor.search(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        page: 0,
      );

      expect(users.isSuccess, equals(false));
      expect(users.isNetworkError, isNotNull);
      expect(users.getOrNull(), isNull);
      expect(users.getFailure().message, 'error_message');

      Axelor.close();
    });
  });

  group('Advanced Axelor Search Function', () {
    test('Success', () async {
      initAxelor('/rest/search/success_search', pageSize: 8, requestChecker: (request) {
        expect(request.data, equals(FixtureReader.readJson('/rest/search/advance_search_body')));
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/' + AxelorApiAction.search.row,
        );
        expect(request.queryParameters, {});
      });

      final users = await Axelor.search(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        page: 0,
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

      expect(users.isSuccess, equals(true));
      expect(users.getOrThrow().errors, isNull);

      expect(users.getOrThrow().status, equals(0));
      expect(users.getOrThrow().isEmpty, equals(false));
      expect(users.getOrThrow().nextPage, equals(1));
      expect(users.getOrThrow().page, equals(0));
      expect(users.getOrThrow().total, equals(100));
      expect(users.getOrThrow().canLoadMore, true);
      expect(users.getOrThrow().haveData, equals(true));

      expect(users.getOrThrow().data?.length, equals(8));

      expect(
        users.getOrThrow().data?.first,
        equals(const UserModel(id: 1, version: 1, email: 'j.smith@gmail.com', fullName: 'John Smith')),
      );

      expect(
        users.getOrThrow().data?.last,
        equals(const UserModel(id: 15, version: 0, email: 'tom.boy15@gmail.com', fullName: 'Tom Boy 15')),
      );

      Axelor.close();
    });

    test('Failure', () async {
      initAxelor('/rest/errors/failure', pageSize: 8, requestChecker: (request) {
        expect(request.data, equals(FixtureReader.readJson('/rest/search/advance_search_body')));
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/' + AxelorApiAction.search.row,
        );
        expect(request.queryParameters, {});
      });

      final users = await Axelor.search(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        page: 0,
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
        expect(request.data, equals(FixtureReader.readJson('/rest/search/advance_search_body')));
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/' + AxelorApiAction.search.row,
        );
        expect(request.queryParameters, {});
      });

      final users = await Axelor.search(
        baseDomain: true,
        model: UserModel.modelName,
        mapper: UserModel.fromJson,
        page: 0,
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
