#include <iostream>
#include <mysql++.h>
#include "mysqlQuery.hpp"

using namespace std;

matrixStatus getMatrixStatus(std::string name) {
#ifdef USE_FAKE_WRAPPER
  mysqlpp::TCPConnection conn("tmt-mysql.eosl.gtri.org", "tmtdbdev", "tmt", "tmt4u");
#else
  mysqlpp::TCPConnection conn("mysql.gatech.edu", "tmt_ircm", "tmt_auto", "tmt4u");
#endif
  mysqlpp::Query query = conn.query("select status from testmatrixinstance where name = ");
  query << mysqlpp::quote_only << name;
  mysqlpp::StoreQueryResult res = query.store();
  if (!res) {
    cerr << "Failed to get testmatrix list: " << query.error() << endl;
    return ERROR;
  }
  if (res.num_rows() == 0)
    return NONE;
  if (res.num_rows() > 1) {
    cerr << "Found multiple matrices named " << name << endl;
    return ERROR;
  }
  mysqlpp::String status = res[0][0];
  if (status == "COMPLETE")
    return FINISHED;
  if (status == "RUNNING" || status == "QUEUED")
    return STARTED;
  return ERROR;
}

double getMatrixResult(std::string name) {
#ifdef USE_FAKE_WRAPPER
  mysqlpp::TCPConnection conn("tmt-mysql.eosl.gtri.org", "tmtdbdev", "tmt", "tmt4u");
  mysqlpp::Query query = conn.query("SELECT avg(randomnumberoutput) FROM testmatrixinstance join testcase on testmatrixinstance.testmatrixinstanceid = testcase.testmatrixinstanceid join testcasenode on testcase.testcaseid = testcasenode.testcaseid join wrappertable on testcasenode.wrappertableid = wrappertable.wrappertableid join error3_0 on wrapperrowid = Error3_0Id where wrappertable.name = 'Error3_0' and testmatrixinstance.name = ");
#else
  mysqlpp::TCPConnection conn("mysql.gatech.edu", "tmt_ircm", "tmt_auto", "tmt4u");
  mysqlpp::Query query = conn.query("SELECT avg(ProbabilityOfMiss) FROM testmatrixinstance join testcase on testmatrixinstance.testmatrixinstanceid = testcase.testmatrixinstanceid join testcasenode on testcase.testcaseid = testcasenode.testcaseid join wrappertable on testcasenode.wrappertableid = wrappertable.wrappertableid join disamspostprocess on wrapperrowid = DisamsPostProcessId where wrappertable.name = 'DisamsPostProcess' and testmatrixinstance.name = ");
#endif
  query << mysqlpp::quote_only << name;
  mysqlpp::StoreQueryResult res = query.store();
  if (!res) {
    cerr << "Failed to get testmatrix result: " << query.error() << endl;
    return ERROR;
  }
  if (res.num_rows() == 0)
    return 0.0;
  return res[0][0];
}

std::string getMatrixPattern(int id, std::string flarePatternName) {
  string currentPatternName = "Genome_" + to_string(id) + "_" + flarePatternName;
  mysqlpp::TCPConnection conn("mysql.gatech.edu", "tmt_ircm", "tmt_auto", "tmt4u");
  mysqlpp::Query query = conn.query("SELECT FlarePattern FROM Missile where FlarePatternName = ");
  query << mysqlpp::quote_only << currentPatternName;
  query << " limit 1";
  mysqlpp::StoreQueryResult res = query.store();
  string retval;
  if (!res)
    cerr << "Failed to get testmatrix result: " << query.error() << endl;
  else if (res.num_rows() > 0)
    res[0][0].to_string(retval);
  return retval;
}
