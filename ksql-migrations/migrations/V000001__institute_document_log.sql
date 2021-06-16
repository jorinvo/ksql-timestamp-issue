set 'auto.offset.reset' = 'earliest';

create or replace stream "institute_document_log" (
  "transaction_id" bigint,
  "transaction_time" varchar
) with
  (kafka_topic='institute_document_log', value_format='JSON');
