Return-Path: <fio-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28196 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932098AbeFFSkH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Jun 2018 14:40:07 -0400
From: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Subject: latency percentiles labels in fio minimal output
Date: Wed, 6 Jun 2018 18:40:05 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9287FF90FB2@ORSMSX113.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi folks-

When using FIO minimal output such as this output example (from FIO v3.6):

3;fio-3.6;1m-sr-01-01-32;0;0;150288384;2503763;2444;60025;0;17189;114.724224;942.095768;0;33799;12973.415812;9008.249487;1.000000%=0;5.000000%=0;10.000000%=173;20.000000%=3358;30.000000%=6586;40.000000%=9764;50.000000%=12648;60.000000%=16187;70.000000%=19267;80.000000%=22675;90.000000%=25821;95.000000%=27394;99.000000%=28704;99.500000%=28966;99.900000%=29229;99.950000%=29491;99.990000%=32112;0%=0;0%=0;0%=0;0;33799;13088.507365;9021.958807;671744;1828428;49.297242%;1234286.100000;498063.813528;0;0;0;0;0;0;0.000000;0.000000;0;0;0.000000;0.000000;1.000000%=0;5.000000%=0;10.000000%=0;20.000000%=0;30.000000%=0;40.000000%=0;50.000000%=0;60.000000%=0;70.000000%=0;80.000000%=0;90.000000%=0;95.000000%=0;99.000000%=0;99.500000%=0;99.900000%=0;99.950000%=0;99.990000%=0;0%=0;0%=0;0%=0;0;0;0.000000;0.000000;0;0;0.000000%;0.000000;0.000000;2.967146%;23.249034%;175862;0;8208;0.1%;0.1%;0.1%;0.1%;0.1%;199.9%;0.0%;9.45%;0.01%;0.02%;0.03%;0.10%;0.16%;0.49%;0.77%;0.78%;0.79%;3.11%;6.25%;18.77%;31.26%;28.03%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%

What's the point of having the latency percentiles labeled in the output data, such as:

99.000000%=28704;99.500000%=28966;99.900000%=29229;99.950000%=29491;99.990000%=32112

The fields in the comma separated output are already defined so I'm not sure why we need the part in front of and including the '=' sign.  I suppose it is more human readable, but that isn't the point of the minimal mode... right?  For example, for IOPS in this example, we just print '2444', we don't print 'IOPS=2444' in the minimal output.

The reason this is problematic is when doing something like pasting the minimal output into a spreadsheet and then charting the output data I now don't have numerical values for the latency percentiles, I have these text strings instead.  Instead of:

99.000000%=28704;99.500000%=28966;99.900000%=29229;99.950000%=29491;99.990000%=32112

It seems it would be much more useful if it just printed like this:

28704,28966,29229,29491,32112

Does that make sense?  Is there a reason for the way it is currently done, am I missing something?  Would it make sense to change it?

Thanks!
