import 'package:flutter/material.dart';
import 'package:gmail_send/services/sendgmail.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomePageViewBody(),
    );
  }
}

class HomePageViewBody extends StatelessWidget {
  const HomePageViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text('data')],
    );
  }
}

class Sendotp extends StatefulWidget {
  const Sendotp({super.key});

  @override
  State<Sendotp> createState() => _SendotpState();
}

class _SendotpState extends State<Sendotp> {
  @override
  void initState() {
    upliftFromController.text =
        'TBC Conversions,50 Far Circular Road, Dungannon, BT71 6LW';
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  final TextEditingController upliftDateController = TextEditingController();
  final TextEditingController deliverDateController = TextEditingController();
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController upliftFromController = TextEditingController();
  final TextEditingController deliverToController = TextEditingController();
  final TextEditingController commentsControlkler = TextEditingController();
  final TextEditingController otheremail = TextEditingController();
  final List<String> emailsList = [];
  final TextEditingController otherEmails = TextEditingController();

  Future<void> selectupliftDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        upliftDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> selectDeliverDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deliverDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future showdelivertoDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setstates) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Choose Deliver To',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: deliverToList.length,
                        itemBuilder: (context, index) {
                          var deliver = deliverToList[index];
                          return InkWell(
                              onTap: () {
                                deliverToController.text = deliver;
                                setState(() {});
                                setstates(() {});
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(deliver),
                              ));
                        }),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future showemailadddialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setstates) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Choose CC Email',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: emailClassList.length,
                        itemBuilder: (context, index) {
                          var emails = emailClassList[index];
                          return Row(
                            children: [
                              Checkbox(
                                  value: emails.isselected,
                                  onChanged: (val) {
                                    emails.isselected = !emails.isselected;
                                    setstates(() {});
                                  }),
                              Expanded(child: Text(emails.name))
                            ],
                          );
                        }),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              emailsList.clear();
                              for (var element in emailClassList) {
                                if (element.isselected == true) {
                                  element.isselected = false;
                                }
                              }
                              setstates(() {});
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              emailsList.clear();
                              for (var element in emailClassList) {
                                if (element.isselected == true) {
                                  emailsList.add(element.name);
                                  element.isselected = false;
                                }
                              }
                              setstates(() {});
                              Navigator.of(context).pop();
                            },
                            child: const Text('Ok'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('TBC Conversations'),
          backgroundColor: Colors.amber,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                width: double.infinity,
                color: Colors.white,
                child: ListView(
                  children: [
                    buildTetfieldWidget('Uplift date', 'Select Uplift Date',
                        controller: upliftDateController,
                        readonly: true, function: () {
                      selectupliftDate(context);
                    }),
                    buildTetfieldWidget('Deliver date', 'Select Deliver Date',
                        controller: deliverDateController,
                        readonly: true, function: () {
                      selectDeliverDate(context);
                    }),
                    buildTetfieldWidget(
                        'REG/Chassis number', 'Enter REG/Chassis Number',
                        function: () {}, controller: regNumberController),
                    buildTetfieldWidget('Uplift From', 'enter Uplift From',
                        function: () {},
                        maxlines: 3,
                        controller: upliftFromController),
                    buildTetfieldWidget('Deliver To', 'Select deliver',
                        readonly: true, function: () {
                      showdelivertoDialog();
                    }, controller: deliverToController),
                    buildTetfieldWidget('Comments', 'enter comments',
                        function: () {}, controller: commentsControlkler),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Select Email Address"),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: emailsList.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        showemailadddialog().then((value) {
                                          setState(() {});
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            children: emailsList
                                                .map((e) => Text(e))
                                                .toList()),
                                      ),
                                    )
                                  : TextField(
                                      onTap: () {
                                        showemailadddialog().then((value) {
                                          setState(() {});
                                        });
                                      },
                                      readOnly: true,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.all(10),
                                          border: InputBorder.none,
                                          hintText: 'Select Emails',
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    buildTetfieldWidget('other email', 'enter other Email',
                        function: () {}, controller: otherEmails),
                    const SizedBox(height: 20),
                    MaterialButton(
                      onPressed: () async {
                        emailsList.add(otherEmails.text);
                        openGmail(
                            emailsList,
                            upliftDateController.text,
                            deliverDateController.text,
                            regNumberController.text,
                            upliftFromController.text,
                            deliverToController.text,
                            commentsControlkler.text);
                        emailsList.clear();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber,
                        ),
                        child: const Center(
                          child: Text('Send Email'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100)
                  ],
                ),
              ))
            ],
          ),
        ));
  }

  List<EmailClass> emailClassList = [
    EmailClass(name: 'info@cartransportni.com', isselected: false),
    EmailClass(name: 'neil@tbcconversions.com', isselected: false),
    EmailClass(name: 'cathy@tbc-conversions.co.uk', isselected: false),
    EmailClass(name: 'tom@tbc-conversions.co.uk', isselected: false),
    EmailClass(name: 'joanne@tbc-conversions.co.uk', isselected: false),
    EmailClass(name: 'christina@tbcconversions.com', isselected: false),
    EmailClass(name: 'donavan@tbcconversions.com', isselected: false),
    EmailClass(name: 'niall@tbcconversions.com', isselected: false),
    EmailClass(name: 'malcolm.kerr@donnellygroup.co.uk', isselected: false),
    EmailClass(name: 'deirdre@tbcconversions.com', isselected: false),
    EmailClass(name: 'tina.emberson@tbcconversions.com', isselected: false),
    EmailClass(name: 'ray@tbcconversions.com', isselected: false),
    EmailClass(name: 'scott@tbcconversions.com', isselected: false),
    EmailClass(name: 'tony@tbcconversions.com', isselected: false),
    EmailClass(name: 'anita@tbcconversions.com', isselected: false),
    EmailClass(name: 'stephen@tbcconversions.com', isselected: false),
    EmailClass(name: 'gareth@tbcconversions.com', isselected: false)
  ];

  List<String> deliverToList = [
    'Adaptacar, Pathfields Business Park, South Molton, North Devon, EX36 3LH',
    'Auto Mobility Concepts, UNIT 2, MAXTED CORNER, MAYLANDS INDUSTRIAL ESTATE, HEMEL HEMPSTEAD, HERTFORDSHIRE, HP2 7RA',
    'AVH Ltd, Unit 508, Stone Close, West Drayton, UB7 8JU',
    'Bradley Auto services, 19 School Lane Warrington, WA3 6LJ',
    'Breeze Van Centre, YARROW ROAD, TOWER PARK, POOLE, DORSET, BH12 4QY',
    'Bristol Street Motors, UNIT 2, CARLINGHOW MILLS, 501 BRADFORD ROAD, BATLEY, WEST YORKSHIRE, WF17 8LL',
    'Brook Millar, UNIT 1A, ELLAND LANE, ELLAND, HALIFAX, HX5 9DZ',
    'Car and Marine Connection, UNIT 7B, MARITIME BUSINESS PARK, SOVEREIGN WAY, WALLASEY, CH41 1DL',
    'CEA Mobility, CEA MOBILITY, UNIT 11, COBBLESTONE WAY, NEWARK ROAD, PETERBOROUGH, PE1 5WJ',
    'City Motor Services, UNIT C10 SPRINGMEADOW BUSINESS PARK, SPRINGMEADOW ROAD, CARDIFF, CF3 2ES',
    'Clarck Commercials Edinburgh, CLARK COMMERCIALS LTD, Moorfoot View, A701, Bilston, Edinburgh, EH25 9SL',
    'Clark Commercials Aberdeen, CLARK COMMERCIALS VAN CENTRE, 30 WELLHEADS DRIVE, DYCE, ABERDEEN, AB21 7GQ',
    'Convertacar, RICHMOND HOUSE, PARKVALE AVENUE, NORTH CHESHIRE TRADING, ESTATE, PRENTON, WIRRAL, CH43 3HG',
    'Cordwallis Van Centre, GREAT SOUTH WEST ROAD, BEDFONT, MIDDLESSEX, TW14 8ND',
    'Cowal Mobility Aids, GREAT KINSHILL ROAD, NEAR HIGH WYCOMBE, HP15 6HL',
    'Da Vinci Mobility, Unit 6-8 Gilmoss Industrial Estate, Carraway Road, Liverpool, L11 0EE',
    'Des Gosling, Unit 10 Station Yard, Station Road, Melbourne, Derbyshire, DE73 8HJ',
    'Driffield Mobility LTD, SCOTCHBURN GARTH, SKERNE ROAD, DRIFFIELD, EAST YORKSHIRE, YO25 6EF',
    'Elap Mobility, ELAP MOBILITY, FORT STREET, ACCRINGTON, BB5 1QG',
    'Ergo Mobility, Units 2 & 3, Crosspost Ind Park, Cowfold Road, Bolney, West Sussex, RH175QU',
    'Five Star, Five Star Vehicle Deliveries Ltd, Meiklewood Business Park, Glasgow Road, Kilmarnock, KA3 6AG',
    'GENUS BREEDING LIMITED, Unit 29, Ilton, Ilminster, Somerset, TA19 9DU',
    'GENUS BREEDING LIMITED, Unit 2, The Millennium Building, Pinkney Park, Malmsbury, Wiltshire, SN16 0NX',
    'GENUS BREEDING LIMITED, UNIT 14I HYBRIS BUSINESS PARK, WARMWELL ROAD, CROSSWAYS, DORSET, DT2 8BF',
    'GENUS BREEDING LIMITED, UNIT 5 CRANMERE ROAD, EXETER ROAD IND EST, OKEHAMPTON, DEVON, EX201UE',
    'GENUS BREEDING LIMITED, ALPHA BUILDING, LONDON ROAD, NANTWICH, CHESHIRE, CW5 7JW',
    'GENUS BREEDING LIMITED, HENFAES LANE, WELSHPOOL, POWYS, SY21 7BE',
    'GENUS BREEDING LIMITED, UNIT 22, BAILEY BUSINESS PARK, AMBER DRIVE, LANGLEY MILL, NOTTINGHAM, NG16 4BE',
    'GENUS BREEDING LIMITED, THE GARDEN VILLAGE, HAWKSHAW PARK, LONGSIGHT ROAD, CLAYTON-LE DALE, BLACKBURN, LANCASHIRE, BB2 7JA',
    'GENUS BREEDING LIMITED, CHAIMERSTON FARM, CHAIMERSTON ROAD, STIRLING, FK9 4AG',
    'GENUS BREEDING LIMITED, 151 HYNDFORD ROAD, LANARK, SOUTH LANARKSHIRE, ML11 9BG',
    'GENUS BREEDING LIMITED, EDEN CONFERENCE BARN, SPITTALS FARM, LOW MOOR, PENRITH, CA10 1XQ',
    'GENUS BREEDING LIMITED, CHESHIRE DEPOT, DAIRY HOUSE FARM, WORLESTON, NANTWICH, CHESHIRE, CW5 6DN',
    'GENUS BREEDING LIMITED, UNIT 4B, CILLEFWR IND ESTATE, JOHNSTOWN, CARMARTHEN, SA31 3RB',
    'GENUS BREEDING LIMITED, UNIT 34A SEAGOE IND AREA, PORTADOWN, CRAIGAVON, BT63 5QD',
    'GENUS BREEDING LIMITED, UNIT 7E, CARMINOW ROAD INDUSTRIAL ESTATE, BODMIN, CORNWALL, PL31 1EP',
    'Goulding, 10 GREATFIELD DRIVE, CHARLTON KINGS, CHELTENHAM, GL53 9BU',
    'Highland Council, 94 DIRIEBUGHT ROAD, IVERNESS, IV2 3QN',
    'JAG Ltd, Jubilee Automotive Group, JAG Ltd., Woden Road South, Wednesbury, West Midlands, WS10 0NQ, 01215022252',
    'Jim Doran Hand Controls, 229 TORRINGTON AVENUE, TILE HILL, COVENTRY, CV4 9HN',
    'Listers Van Centre, 347-367 Bedworth Road, Longford, Coventry, West Midlands, CV6 6BN',
    'Manheim Auction Centres, 199 SIEMENS ST, GLASGOW, G21 2BU',
    'Marshall VW, 191 Bristol Rd, Bridgwater, TA6 4BJ',
    'Mobility Care Solutions, Unit 12B, Southwick Industrial Estate, North Hylton Road, Sunderland, SR5 3TX',
    'PB Conversions, Unit 1&2 Clipstone Brook Ind Est, Cherrycourt Way, Leighton Buzzard, Bedfordshire, LU7 4GP',
    'PL Mobility, 1 Murnin Road, BONNYBRIDGE, FK4 2BW',
    'S&B Commercials, Travellers Lane, Welham Green, Hatfield, Hertfordshire, AL9 7HN',
    'Sirus Automotive Ltd, UNIT 2 BRITANNIA PARK, TRIDENT DRIVE, WEDNESDBURY, WEST MIDLANDS, WS10 7XB',
    'Steering Developments, UNIT 5 EASTMAN WAY, HEMEL HEMPSTEAD, HERTFORDSHIRE, HP2 7HF',
    'SVO, Unit K, Stanier Road, Porte Marsh Industrial Estate, Calne, Wiltshire, SN11 9PX',
    'TBC Dungannon, 50 Far Circular Road, Dungannon, Co Tyrone, BT71 6LW',
    'TBC Liverpool - TBC Conversions, Unit 3 Brunel Road, Bromborough, CH62 3NY',
    'Techmobility, UNIT L, CHANDLERS ROW, PORT LANE, COLCHESTER, CO1 2HG',
    'The Taxi Centre Glasgow, The Taxi Centre, Glasgow Airport Business Park, Pavilion 5, Marchburn Drive, Paisley, PA3 2SJ',
    'Versatile Motor Company LTD, 31 FOLLY FARM, KINGSCLERE ROAD, BASINGSTOKE, RG26 5GJ',
    'Vertu Van Centre, CENTURION WAY, ROMAN ROAD, HEREFORD, HR1 1LQ',
    'VW Van Centre (Bury St Edmonds), Marriott, Suffolk, IP32 6NL',
    'VW Van Centre (Cardiff), SINCLAIRS, TYNDALL STREET, WHARF ROAD EAST, CARDIFF, S WALES, CF10 4BB',
    'VW Van Centre (Edinburgh), VW Van Centre (Edinburgh), Moorfoot View, Bilston, EDINBURGH, EH25 9SL',
    'VW Van Centre (Glasgow), Springcroft Road, Glasgow Business Park, Baillieston, Glasgow, G69 6GA',
    'VW Van Centre (Lancashire), Millennium Road, Off Bluebell Way, Ribbleton, Preston, Lancashire, PR2 5BL',
    'VW Van Centre (Swansea), SINCLAIRS, GORSEINON ROAD, PENLIERGAER, SWANSEA, SA4 9GW',
    'VW Van Centre (West Yorkshire), L C W House, Chain Bar Road, Cleckheaton, BD19 3QF',
    'VW Van Centre (West Yorkshire), L C W House, Chain Bar Road, Cleckheaton, BD19 3QF'
  ];
}

class EmailClass {
  final String name;
  bool isselected;

  EmailClass({required this.name, required this.isselected});
}

buildTetfieldWidget(String title, String hinttext,
    {int? maxlines,
    required TextEditingController controller,
    bool readonly = false,
    required Function() function}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TextField(
              onTap: function,
              readOnly: readonly,
              controller: controller,
              maxLines: maxlines,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(10),
                  border: InputBorder.none,
                  hintText: hinttext,
                  hintStyle: const TextStyle(color: Colors.grey)),
            ),
          ),
        ),
      ],
    ),
  );
}
