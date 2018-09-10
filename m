Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pl1-f178.google.com ([209.85.214.178]:33197 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbeIKDUT (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Sep 2018 23:20:19 -0400
Received: by mail-pl1-f178.google.com with SMTP id b30-v6so8089580pla.0
        for <fio@vger.kernel.org>; Mon, 10 Sep 2018 15:24:08 -0700 (PDT)
Date: Mon, 10 Sep 2018 15:24:04 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: graphing with fio - architectural docs - gfio Vs fiovisualizer
Message-ID: <20180910222404.GB3456@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: andrey.o.kudryavtsev@intel.com, mcgrof@kernel.org, jblunck@infradead.org

I've been doing an analysis of graphing with fio with the different
options I was able to find out there. Documentation was pretty much
non-existant so I wrote some stuff up for my own ingestion but then
it also became a way for me to review fiovisualizer and to call out
that perhaps effort is best put into gfio.

In the end I did a full analysis of differences between both, and this
really lead to the effort to document clearly the differences between
fio's status interval dumps, eta interval checks, and time resolutions
possible.

The doc is up here:

https://gitlab.com/mcgrof/graphing-with-fio

Please give it some review and let me know your thoughts, rants,
disagreements.  Perhaps with time, after things are actually set up and
documented correctly, if folks consider it proper, I could massage it
and put the generic fio stuff into documentation for fio upstream.

  Luis

