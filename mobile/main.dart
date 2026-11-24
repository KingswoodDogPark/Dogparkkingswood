import 'package:flutter/material.dart';

void main() => runApp(const KingswoodApp());
const forest = Color(0xff23462c);
const cream = Color(0xfff5f1e8);
const sage = Color(0xffe4ebdc);
const fields = ['Small Paddock 1','Small Paddock 2','Large Paddock 1','Large Paddock 2'];
const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];

class KingswoodApp extends StatelessWidget {
  const KingswoodApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Kingswood Dog Park',
    theme: ThemeData(useMaterial3:true, colorScheme:ColorScheme.fromSeed(seedColor:forest), scaffoldBackgroundColor:cream),
    home: const BookingScreen(),
  );
}

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final today = DateUtils.dateOnly(DateTime.now());
  late DateTime selected = today;
  late DateTime month = DateTime(today.year,today.month);
  int field = 0;
  int dogs = 1;
  int? slot;
  double get price => (field < 2 ? 8.0 : 10.0) + (dogs > 3 ? (dogs-3)*2.5 : 0);
  String get dateLabel => '${selected.day} ${months[selected.month-1]} ${selected.year}';
  String time(int n) => '${(8+n~/2).toString().padLeft(2,'0')}:${n.isEven?'00':'30'}';
  bool past(int n) => DateTime(selected.year,selected.month,selected.day,8+n~/2,n.isEven?0:30).isBefore(DateTime.now());
  void moveMonth(int amount) => setState(() => month = DateTime(month.year,month.month+amount));
  Widget heading(String n,String label) => Padding(
    padding:const EdgeInsets.only(bottom:12),
    child:Row(children:[CircleAvatar(radius:13,backgroundColor:forest,child:Text(n,style:const TextStyle(color:Colors.white,fontSize:12))),const SizedBox(width:9),Text(label,style:const TextStyle(fontSize:19,fontWeight:FontWeight.w700,color:forest))]),
  );
  Widget panel(Widget child) => Container(
    margin:const EdgeInsets.only(bottom:18), padding:const EdgeInsets.all(16),
    decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),border:Border.all(color:const Color(0xffe3e5dc))),
    child:child,
  );
  Widget calendar() {
    final offset=month.weekday-1;
    final days=DateUtils.getDaysInMonth(month.year,month.month);
    return Column(children:[
      Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
        IconButton(onPressed:month.isAfter(DateTime(today.year,today.month))?()=>moveMonth(-1):null,icon:const Icon(Icons.chevron_left)),
        Text('${months[month.month-1]} ${month.year}',style:const TextStyle(fontSize:17,fontWeight:FontWeight.bold,color:forest)),
        IconButton(onPressed:month.isBefore(DateTime(today.year,today.month+12))?()=>moveMonth(1):null,icon:const Icon(Icons.chevron_right)),
      ]),
      Row(children:[
        for(final day in ['M','T','W','T','F','S','S']) Expanded(child:Center(child:Text(day,style:TextStyle(color:Colors.black54,fontWeight:FontWeight.w600))))
      ]),
      const SizedBox(height:8),
      GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:((days+offset+6)~/7)*7,
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:7,mainAxisSpacing:4,crossAxisSpacing:4),
        itemBuilder:(context,i){
          final d=i-offset+1;
          if(d<1||d>days) return const SizedBox.shrink();
          final date=DateTime(month.year,month.month,d);
          final disabled=date.isBefore(today);
          final active=DateUtils.isSameDay(date,selected);
          return Material(color:active?forest:Colors.transparent,borderRadius:BorderRadius.circular(12),child:InkWell(
            borderRadius:BorderRadius.circular(12),onTap:disabled?null:()=>setState((){selected=date;slot=null;}),
            child:Center(child:Text('$d',style:TextStyle(color:disabled?Colors.black26:active?Colors.white:forest,fontWeight:active?FontWeight.bold:FontWeight.w500))),
          ));
        },
      ),
    ]);
  }
  Future<void> review() async {
    if(slot==null)return;
    showModalBottomSheet<void>(context:context,isScrollControlled:true,backgroundColor:Colors.white,showDragHandle:true,builder:(context)=>SafeArea(child:Padding(
      padding:const EdgeInsets.fromLTRB(24,8,24,24),
      child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        const Text('Your booking',style:TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:forest)),
        const SizedBox(height:18),
        ListTile(contentPadding:EdgeInsets.zero,leading:const Icon(Icons.pets),title:Text(fields[field]),subtitle:Text('$dogs dog${dogs==1?'':'s'}')),
        ListTile(contentPadding:EdgeInsets.zero,leading:const Icon(Icons.calendar_month),title:Text(dateLabel),subtitle:Text('${time(slot!)} – ${time(slot!+1)}')),
        const Divider(),
        Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('Total',style:TextStyle(fontSize:19,fontWeight:FontWeight.w600)),Text('£${price.toStringAsFixed(2)}',style:const TextStyle(fontSize:26,fontWeight:FontWeight.bold,color:forest))]),
        const SizedBox(height:18),
        const Text('Preview only. Live availability and payment are not connected yet. No reservation will be made.',style:TextStyle(color:Colors.black54)),
        const SizedBox(height:16),
        FilledButton(onPressed:()=>Navigator.pop(context),style:FilledButton.styleFrom(backgroundColor:forest,padding:const EdgeInsets.all(16)),child:const Text('Back to booking')),
      ]),
    )));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(backgroundColor:forest,foregroundColor:Colors.white,centerTitle:true,toolbarHeight:68,title:const Row(mainAxisSize:MainAxisSize.min,children:[Icon(Icons.pets,size:27),SizedBox(width:10),Column(children:[Text('KINGSWOOD',style:TextStyle(fontSize:19,letterSpacing:2,fontWeight:FontWeight.bold)),Text('D O G  P A R K',style:TextStyle(fontSize:9,letterSpacing:2))])])),
    body:SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(18,22,18,20),children:[
      const Text('Book your adventure',style:TextStyle(fontSize:29,fontWeight:FontWeight.bold,color:forest,letterSpacing:-.8)),
      const SizedBox(height:5),
      const Text('Your own private space to run and explore.',style:TextStyle(color:Colors.black54,fontSize:14)),
      const SizedBox(height:12),
      Container(padding:const EdgeInsets.all(10),decoration:BoxDecoration(color:sage,borderRadius:BorderRadius.circular(10)),child:const Text('DEMO • Times are examples, not live availability',style:TextStyle(color:forest,fontSize:12,fontWeight:FontWeight.w600))),
      const SizedBox(height:20),
      heading('1','Choose a date'),panel(calendar()),
      heading('2','Choose your paddock'),
      panel(Column(children:[
        for(int i=0;i<4;i++) Padding(padding:const EdgeInsets.only(bottom:8),child:Material(
          color:field==i?sage:cream,borderRadius:BorderRadius.circular(13),
          child:InkWell(borderRadius:BorderRadius.circular(13),onTap:()=>setState((){field=i;slot=null;}),
            child:Padding(padding:const EdgeInsets.all(13),child:Row(children:[
              Icon(field==i?Icons.check_circle:Icons.radio_button_unchecked,color:forest),
              const SizedBox(width:12),Expanded(child:Text(fields[i],style:const TextStyle(fontWeight:FontWeight.w600,color:forest))),
              Text('£${i<2?8:10}',style:const TextStyle(fontWeight:FontWeight.bold,color:forest)),
            ])),
          ),
        )),
      ])),
      heading('3','Select a time'),
      panel(Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text('$dateLabel • 30-minute example sessions',style:const TextStyle(color:Colors.black54,fontSize:13)),
        const SizedBox(height:12),
        GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:22,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:4,childAspectRatio:1.65,mainAxisSpacing:8,crossAxisSpacing:8),
          itemBuilder:(context,i)=>OutlinedButton(
            onPressed:past(i)?null:()=>setState(()=>slot=i),
            style:OutlinedButton.styleFrom(padding:EdgeInsets.zero,backgroundColor:slot==i?forest:Colors.white,foregroundColor:slot==i?Colors.white:forest,side:BorderSide(color:slot==i?forest:const Color(0xffd8dfd2)),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(10))),
            child:Text(time(i),style:const TextStyle(fontWeight:FontWeight.w600,fontSize:13)),
          ),
        ),
      ])),
      heading('4','How many dogs?'),
      panel(Row(children:[
        const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Dogs attending',style:TextStyle(fontWeight:FontWeight.bold,color:forest)),Text('3 included • £2.50 per extra dog',style:TextStyle(fontSize:11,color:Colors.black54))])),
        IconButton(onPressed:dogs>1?()=>setState(()=>dogs--):null,icon:const Icon(Icons.remove_circle_outline,color:forest)),
        Text('$dogs',style:const TextStyle(fontSize:20,fontWeight:FontWeight.bold)),
        IconButton(onPressed:dogs<6?()=>setState(()=>dogs++):null,icon:const Icon(Icons.add_circle_outline,color:forest)),
      ])),
    ])),
    bottomNavigationBar:SafeArea(child:Container(
      padding:const EdgeInsets.fromLTRB(18,12,18,12),
      decoration:const BoxDecoration(color:Colors.white,border:Border(top:BorderSide(color:Color(0xffe3e5dc)))),
      child:Row(children:[
        Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Total price',style:TextStyle(color:Colors.black54,fontSize:12)),Text('£${price.toStringAsFixed(2)}',style:const TextStyle(color:forest,fontWeight:FontWeight.bold,fontSize:24))]),
        const SizedBox(width:20),
        Expanded(child:FilledButton(onPressed:slot==null?null:review,style:FilledButton.styleFrom(backgroundColor:forest,padding:const EdgeInsets.symmetric(vertical:17),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))),child:const Text('Review booking  →',style:TextStyle(fontWeight:FontWeight.bold)))),
      ]),
    )),
  );
}
