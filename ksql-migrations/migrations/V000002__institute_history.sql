set 'auto.offset.reset' = 'earliest';

create or replace stream "institute_history"
with (
  value_format='PROTOBUF'
)
as
select
  "transaction_id",
  parse_timestamp("transaction_time", 'yyyy-MM-dd''T''HH:mm:ss.SSS''Z''') as "transaction_time"
from "institute_document_log"
emit changes;

