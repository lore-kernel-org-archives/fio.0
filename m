Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56167 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbhD0S7U (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Apr 2021 14:59:20 -0400
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: setup vs init ioengine callback order
Date: Tue, 27 Apr 2021 18:58:33 +0000
Message-ID: <YIhe2FkdoJMnXoHl@x1-carbon.lan>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <614300C81E24E7479B72061A602E27DF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hello there,


If running fio with --create_serialize=3D1 and --numjobs=3D2

->setup() callback will be called for each thread,
before the ->init() callback is called for each thread:

my_fio_setup: td: 0x7eff72d6a000
my_fio_setup: td: 0x7eff72daea70
my_fio_init: td: 0x7eff72d6a000
my_fio_init: td: 0x7eff72daea70

However, if running fio with --create_serialize=3D0 and --numjobs=3D2
you will instead see that ->init() callback will be called for each
thread, before the ->setup() callback is called for each thread:

my_fio_init: td: 0x7eff72d6a000
my_fio_init: td: 0x7eff72daea70
my_fio_setup: td: 0x7eff72d6a000
my_fio_setup: td: 0x7eff72daea70


This is because, in backend.c:thread_main() looks like this:

...

        if (!init_iolog(td))
                goto err;

        if (td_io_init(td))
                goto err;

        if (init_io_u(td))
                goto err;

...

        if (!o->create_serialize && setup_files(td))
                goto err;

        if (!init_random_map(td))
                goto err;

...



td_io_init() will call td->io_ops->init(td) and setup_files() will
call td->io_ops->setup(td).

Is it just me who thinks that it is extremely confusing for an ioengine
developer to not be able to know if the ->setup() or ->init() callback
will be called first?

Should we perhaps consider moving the

        if (!o->create_serialize && setup_files(td))
                goto err;

chunk so that it is before the td_io_init() call?

That way, ->setup() would always be called before ->init()
(which is the default, since --create_serialize defaults to 1),
no matter what value --create_serialize is set to.


Kind regards,
Niklas=

