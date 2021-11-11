import 'package:flutter_axelor_sdk/flutter_axelor_sdk.dart';
import 'package:flutter_axelor_sdk/models/axelor_version_model.dart';
import 'package:flutter_axelor_sdk/utils/axelor_body.dart';
import 'package:flutter_test/flutter_test.dart';

import '../models/user_model.dart';
import '../utils/mock_interceptor.dart';

void main() {
  group('Axelor Delete Function', () {
    test('Success', () async {
      initAxelor('/rest/delete/success_delete', requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('DELETE'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(request.queryParameters, equals({}));
      });

      final versionResponse = await Axelor.delete(
        id: 1,
        baseDomain: true,
        model: UserModel.modelName,
      );

      expect(versionResponse.isSuccess, equals(true));

      expect(
        versionResponse.getOrThrow(),
        equals(AxelorVersionModel(id: 1, version: 1)),
      );

      Axelor.close();
    });

    test('Failure', () async {
      initAxelor('/rest/errors/failure', requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('DELETE'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(request.queryParameters, equals({}));
      });

      final versionResponse = await Axelor.delete(
        id: 1,
        baseDomain: true,
        model: UserModel.modelName,
      );

      expect(versionResponse.isSuccess, equals(false));
      expect(versionResponse.isNetworkError, isNotNull);
      expect(versionResponse.getOrNull(), isNull);
      expect(versionResponse.getFailure().message, 'error_message');

      Axelor.close();
    });

    test('Validation Error', () async {
      initAxelor('/rest/errors/validation_error', requestChecker: (request) {
        expect(request.data, isNull);
        expect(request.method, equals('DELETE'));
        expect(request.path, REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/1');
        expect(request.queryParameters, equals({}));
      });

      final versionResponse = await Axelor.delete(
        id: 1,
        baseDomain: true,
        model: UserModel.modelName,
      );

      expect(versionResponse.isSuccess, equals(false));
      expect(versionResponse.isNetworkError, isNotNull);
      expect(versionResponse.getOrNull(), isNull);
      expect(versionResponse.getFailure().message, 'error_message');

      Axelor.close();
    });
  });

  group('Axelor Advance Delete (Delete ALl) Function', () {
    test('Success', () async {
      initAxelor('/rest/delete/success_advance_delete', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/${AxelorApiAction.removeAll.row}',
        );
        expect(request.queryParameters, equals({}));
        expect(
            request.data,
            equals({
              'records': [
                {'id': 1, 'version': 1},
                {'id': 2, 'version': 0}
              ]
            }));
      });

      final records = [
        AxelorVersionModel(id: 1, version: 1),
        AxelorVersionModel(id: 2, version: 0),
      ];

      final deleteResponse = await Axelor.deleteAll(
        baseDomain: true,
        model: UserModel.modelName,
        records: records,
      );

      expect(deleteResponse.isSuccess, equals(true));
      expect(deleteResponse.getOrThrow().errors, isNull);
      expect(deleteResponse.getOrThrow().status, equals(0));
      expect(deleteResponse.getOrThrow().isEmpty, equals(false));
      expect(deleteResponse.getOrThrow().haveData, equals(true));
      expect(deleteResponse.getOrThrow().data?.length, equals(2));

      expect(deleteResponse.getOrThrow().data, equals(records));

      Axelor.close();
    });

    test('Failure', () async {
      initAxelor('/rest/errors/failure', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/${AxelorApiAction.removeAll.row}',
        );
        expect(request.queryParameters, equals({}));
        expect(
            request.data,
            equals({
              'records': [
                {'id': 1, 'version': 1},
                {'id': 2, 'version': 0}
              ]
            }));
      });

      final records = [
        AxelorVersionModel(id: 1, version: 1),
        AxelorVersionModel(id: 2, version: 0),
      ];

      final deleteResponse = await Axelor.deleteAll(
        baseDomain: true,
        model: UserModel.modelName,
        records: records,
      );

      expect(deleteResponse.isSuccess, equals(false));
      expect(deleteResponse.isNetworkError, isNotNull);
      expect(deleteResponse.getOrNull(), isNull);
      expect(deleteResponse.getFailure().message, 'error_message');

      Axelor.close();
    });

    test('Validation Error', () async {
      initAxelor('/rest/errors/validation_error', requestChecker: (request) {
        expect(request.data, isNotNull);
        expect(request.method, equals('POST'));
        expect(
          request.path,
          REST_SERVICE + '/$BASE_MODEL_DOMAIN' + UserModel.modelName + '/${AxelorApiAction.removeAll.row}',
        );
        expect(request.queryParameters, equals({}));
        expect(
            request.data,
            equals({
              'records': [
                {'id': 1, 'version': 1},
                {'id': 2, 'version': 0}
              ]
            }));
      });

      final records = [
        AxelorVersionModel(id: 1, version: 1),
        AxelorVersionModel(id: 2, version: 0),
      ];

      final deleteResponse = await Axelor.deleteAll(
        baseDomain: true,
        model: UserModel.modelName,
        records: records,
      );

      expect(deleteResponse.isSuccess, equals(false));
      expect(deleteResponse.isNetworkError, isNotNull);
      expect(deleteResponse.getOrNull(), isNull);
      expect(deleteResponse.getFailure().message, 'error_message');

      Axelor.close();
    });
  });
}
