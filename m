Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52924 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaHUO2t (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Aug 2014 10:28:49 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so9121166wgg.4
        for <fio@vger.kernel.org>; Thu, 21 Aug 2014 07:28:48 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 21 Aug 2014 07:28:48 -0700
Message-ID: <CALKLVuJSzuooL3PqXY2_LHwQLKBbwzkieTAvbtiFEjVgXzSqfQ@mail.gmail.com>
Subject: Client/Server and output
From: Castor Fu <castor@egocast.org>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've been having problems with the client/server mode of fio where
occasionally I will get CRC errors or packet mismatches.

I think the source of the problem is that the file descriptor for the
socket is 1 or 2 and something is writing to stdout or stderr.  After
I cleaned up some problems with my plugin the problem seems to have
gone away.

It looks like there are a few places where this can happen:

In fio.h fio_assert writes to stderr ... Maybe this should use f_err?

The debug malloc also writes to stderr if it detects memory corruption...

Also in  json_object_add_client_info, if no hostname is specified,
client->hostname is NULL so we'll dump core...

iff --git a/client.c b/client.c
index 1f52734..78a957e 100644
--- a/client.c
+++ b/client.c
@@ -825,7 +825,8 @@ static void convert_gs(struct group_run_stats
*dst, struct group_run_stats *src)
 static void json_object_add_client_info(struct json_object *obj,
 struct fio_client *client)
 {
-       json_object_add_value_string(obj, "hostname", client->hostname);
+       const char *hostname = client->hostname ? client->hostname : "";
+       json_object_add_value_string(obj, "hostname", hostname);
        json_object_add_value_int(obj, "port", client->port);
 }
