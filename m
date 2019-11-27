Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f176.google.com ([209.85.167.176]:44145 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfK0ROP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Nov 2019 12:14:15 -0500
Received: by mail-oi1-f176.google.com with SMTP id s71so20714874oih.11
        for <fio@vger.kernel.org>; Wed, 27 Nov 2019 09:14:15 -0800 (PST)
MIME-Version: 1.0
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Wed, 27 Nov 2019 12:14:03 -0500
Message-ID: <CAHEKYV4x7Re+sa1AADW00j0nR0C7+PUXr8gh7vby4d2h084KjQ@mail.gmail.com>
Subject: rwmixread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On some articles which use fio, I see the following entry in the config file:

rwmixread={100, 70, 0}

Is that a valid entry or just a shorthand to say 3 runs each of them
using one of the percentage values?

