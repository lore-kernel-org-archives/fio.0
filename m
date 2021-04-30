Return-Path: <fio-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6821 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhD3Sjm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Apr 2021 14:39:42 -0400
From: "Johnson, Glen" <glen.johnson@intel.com>
Subject: FIO Frontend Development
Date: Fri, 30 Apr 2021 18:38:50 +0000
Message-ID: <BL0PR11MB31394F526D7FF390F9551496905E9@BL0PR11MB3139.namprd11.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "Luse, Paul E" <paul.e.luse@intel.com>

Hi all,=20

I am part of a development team who is creating a GUI frontend for FIO whic=
h is currently in Alpha status. This frontend is written in Python and uses=
 QT5. We are planning to release this as its own repository on GitHub.  We =
are looking to see if there is interest in the FIO community in hosting the=
 project. We can provide screenshots of the code if it is in interest. One =
of the main benefits of this tool is that it allows for the creation of FIO=
 job files with custom FIO workloads. We also added a custom 'idle' job tha=
t lets the drive idle for a set amount of time (selected in the frontend) d=
uring the runs. In addition we also support the looping of jobs. The tool a=
lso parses the output of FIO and separates the values for log files, as wel=
l as drawing graphs for the IOPS, Bandwidth, and Latency. We see that this =
tool could be very beneficial to FIO users and are planning to keep support=
ing this tool, and adding more features to it. We are very excited about th=
is project and are looking forward to hearing your response!=20

-- Glen Johnson

