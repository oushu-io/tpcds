 -- $Id: hawq.tpl,v 2.1 2016/01/19 09:51:52 jgr Exp $
define __LIMITA = "";
define __LIMITB = "";
define __LIMITC = "limit %d";
define _BEGIN = "--sql_start query " + [_QUERY] + " in stream " + [_STREAM] + " using template " + [_TEMPLATE] + " and seed " + [_SEED];
define _END = "--sql_end query " + [_QUERY] + " in stream " + [_STREAM] + " using template " + [_TEMPLATE];
