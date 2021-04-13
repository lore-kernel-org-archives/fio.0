Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbhDMTQx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Apr 2021 15:16:53 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8420C061574
        for <fio@vger.kernel.org>; Tue, 13 Apr 2021 12:16:32 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id i25-20020a4aa1190000b02901bbd9429832so4082785ool.0
        for <fio@vger.kernel.org>; Tue, 13 Apr 2021 12:16:32 -0700 (PDT)
MIME-Version: 1.0
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date: Tue, 13 Apr 2021 12:16:20 -0700
Message-ID: <CAFCYAsfp-FG4v1AYe=h=ZP8Ka4UCx6GUj_CAkz+4NwmsaK5urw@mail.gmail.com>
Subject: [Question] Passing shell variables from client to server in remote execution
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Greetings,

I'm running fio-3.26 in client-server mode. I have a job file that
takes size from a shell variable ${FILESIZE}.

If I run the following command from the client (control) node, the
shell variable isn't passed to the servers. On each server in
fiohosts.list the /tmp/myjob.fio contains a config line
size=${FILESIZE}

FILESIZE=100G fio --client=fiohosts.list --remote-config=/tmp/myjob.fio

If I switch from using remote config files to a local config file the
shell variable is honored but the execution of the benchmark is serial
where each host in fiohosts.list runs singularly and in sequence as
opposed to concurrently on each server in fiohosts.list.

FILESIZE=100G fio --client=fiohosts.list /tmp/myjob.fio

End goal being concurrent benchmark operations on the same network
share file from all clients in fiohosts.list

Any pointers are appreciated,

--Jeff

