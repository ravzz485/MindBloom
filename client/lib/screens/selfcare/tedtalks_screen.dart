import 'package:flutter/material.dart';

class TedTalksScreen extends StatefulWidget {
  const TedTalksScreen({super.key});

  @override
  State<TedTalksScreen> createState() => _TedTalksScreenState();
}

class _TedTalksScreenState extends State<TedTalksScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'id': 'anxiety',
      'title': 'Anxiety & Panic',
      'emoji': '😰',
      'description': 'De-escalating panic and overthinking',
      'color': const Color(0xFF174143),
      'talks': [
        {
          'title': 'How to Cope with Anxiety',
          'speaker': 'Olivia Remes',
          'duration': '14 min',
          'description':
              'A framework to regain control when feeling frozen by anxiety.',
          'youtube': 'https://www.youtube.com/watch?v=WWloIAQpMcQ',
          'article':
              'https://www.ted.com/talks/olivia_remes_how_to_cope_with_anxiety',
        },
        {
          'title': 'How to Make Anxiety Your Friend',
          'speaker': 'David H. Rosmarin',
          'duration': '12 min',
          'description':
              'Shifting from fear to functional allyship with your anxiety.',
          'youtube': 'https://www.youtube.com/watch?v=7OQFN0hkFME',
          'article':
              'https://www.ted.com/talks/david_h_rosmarin_how_to_make_anxiety_your_friend',
        },
        {
          'title': 'How to Make Stress Your Friend',
          'speaker': 'Kelly McGonigal',
          'duration': '14 min',
          'description':
              'Psychologist urges us to see stress as positive and introduces stress resilience.',
          'youtube': 'https://www.youtube.com/watch?v=RcGyVTAoXEU',
          'article':
              'https://www.ted.com/talks/kelly_mcgonigal_how_to_make_stress_your_friend',
        },
        {
          'title': 'Why You Should Define Your Fears Instead of Your Goals',
          'speaker': 'Tim Ferriss',
          'duration': '13 min',
          'description':
              'A practical mental exercise called fear-setting for high existential anxiety.',
          'youtube': 'https://www.youtube.com/watch?v=5J6jAC6XxAI',
          'article':
              'https://www.ted.com/talks/tim_ferriss_why_you_should_define_your_fears_instead_of_your_goals',
        },
        {
          'title': 'Rethinking Anxiety: Learning to Face Fear',
          'speaker': 'Dawn Huebner',
          'duration': '13 min',
          'description': 'How to stop feeding intrusive anxious thoughts.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNsection',
          'article':
              'https://www.ted.com/talks/dawn_huebner_rethinking_anxiety_learning_to_face_fear',
        },
        {
          'title': 'How to Stop Screwing Yourself Over',
          'speaker': 'Mel Robbins',
          'duration': '21 min',
          'description':
              'Immediate behavioral activation for stuck and anxious procrastinators.',
          'youtube': 'https://www.youtube.com/watch?v=Lp7E973zozc',
          'article':
              'https://www.ted.com/talks/mel_robbins_how_to_stop_screwing_yourself_over',
        },
        {
          'title': 'Surviving Anxiety',
          'speaker': 'Summer Beretsky',
          'duration': '11 min',
          'description':
              'Navigating teen and young adult panic and chronic anxiety.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNroute',
          'article':
              'https://www.ted.com/talks/summer_beretsky_surviving_anxiety',
        },
        {
          'title': 'How to Calm Your Anxiety From a Neuroscientist',
          'speaker': 'Wendy Suzuki',
          'duration': '14 min',
          'description':
              'Immediate breathing and physical movement interventions for anxiety.',
          'youtube': 'https://www.youtube.com/watch?v=MIr3RsUWrdo',
          'article':
              'https://www.ted.com/talks/wendy_suzuki_how_to_calm_your_anxiety_from_a_neuroscientist',
        },
        {
          'title': 'What is Normal Anxiety and What is an Anxiety Disorder',
          'speaker': 'Dr. Jen Gunter',
          'duration': '10 min',
          'description':
              'Maps the brain threat-detection system for those seeking answers.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNsect',
          'article':
              'https://www.ted.com/talks/jen_gunter_what_s_normal_anxiety_and_what_s_an_anxiety_disorder',
        },
        {
          'title': '3 Steps of Anxiety Overload and How to Take Back Control',
          'speaker': 'Lisa Damour',
          'duration': '12 min',
          'description':
              'Breaking down physiological spirals for overwhelmed and panicked users.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNtalks',
          'article':
              'https://www.ted.com/talks/lisa_damour_3_steps_to_manage_anxiety',
        },
      ],
    },
    {
      'id': 'burnout',
      'title': 'Burnout & Stress',
      'emoji': '🔥',
      'description': 'Chronic exhaustion and work-related stress',
      'color': const Color(0xFF8B2500),
      'talks': [
        {
          'title': 'The Cure for Burnout',
          'speaker': 'Emily & Amelia Nagoski',
          'duration': '18 min',
          'description':
              'How to physically close the stress response cycle when completely drained.',
          'youtube': 'https://www.youtube.com/watch?v=5GG7vbHMFMo',
          'article':
              'https://www.ted.com/talks/emily_nagoski_and_amelia_nagoski_the_cure_for_burnout',
        },
        {
          'title': 'How to Succeed Get More Sleep',
          'speaker': 'Arianna Huffington',
          'duration': '4 min',
          'description':
              'Targeting the baseline physiological fix for exhaustion and burnout.',
          'youtube': 'https://www.youtube.com/watch?v=lIW5jTvDoyY',
          'article':
              'https://www.ted.com/talks/arianna_huffington_how_to_succeed_get_more_sleep',
        },
        {
          'title': 'How to Make Work Life Balance Work',
          'speaker': 'Nigel Marsh',
          'duration': '10 min',
          'description':
              'Small realistic adjustments to an overwhelming schedule.',
          'youtube': 'https://www.youtube.com/watch?v=vl-44jDYDJQ',
          'article':
              'https://www.ted.com/talks/nigel_marsh_how_to_make_work_life_balance_work',
        },
        {
          'title': 'The Cost of Hidden Stress',
          'speaker': 'Gabor Maté',
          'duration': '18 min',
          'description':
              'How hidden emotional burnout leads to physical illness.',
          'youtube': 'https://www.youtube.com/watch?v=ajo3xkhTbfo',
          'article':
              'https://www.ted.com/talks/gabor_mate_the_cost_of_hidden_stress',
        },
        {
          'title': 'My Year of Saying Yes',
          'speaker': 'Shonda Rhimes',
          'duration': '18 min',
          'description':
              'Finding joy outside of relentless work for high-functioning stressed people.',
          'youtube': 'https://www.youtube.com/watch?v=gmj-azgTbBU',
          'article':
              'https://www.ted.com/talks/shonda_rhimes_my_year_of_saying_yes_to_everything',
        },
        {
          'title': 'Plug Into Your Hardwired Happiness',
          'speaker': 'Srikumar Rao',
          'duration': '18 min',
          'description':
              'Dealing with extreme workplace pressures and dissatisfaction.',
          'youtube': 'https://www.youtube.com/watch?v=M9i5LDirUfQ',
          'article':
              'https://www.ted.com/talks/srikumar_rao_plug_into_your_hard_wired_happiness',
        },
        {
          'title': 'The Burnout Society',
          'speaker': 'Rahaf Harfoush',
          'duration': '13 min',
          'description':
              'Why our brains hate modern 24/7 productivity culture.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNburn',
          'article':
              'https://www.ted.com/talks/rahaf_harfoush_how_to_fix_your_burnout',
        },
        {
          'title': 'Cracking the Burnout Code',
          'speaker': 'Jacinta M. Jiménez',
          'duration': '12 min',
          'description':
              'Using psychology to rebuild boundaries when mentally exhausted.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNcrack',
          'article':
              'https://www.ted.com/talks/jacinta_jimenez_cracking_the_burnout_code',
        },
        {
          'title': 'The Myth of Productivity',
          'speaker': 'Anne-Laure Le Cunff',
          'duration': '11 min',
          'description':
              'Addressing the stress caused by never feeling like you do enough.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNmyth',
          'article':
              'https://www.ted.com/talks/anne_laure_le_cunff_the_myth_of_productivity',
        },
        {
          'title': 'How to Gain Control of Your Free Time',
          'speaker': 'Laura Vanderkam',
          'duration': '12 min',
          'description':
              'Shifting from I do not have time to smart prioritization.',
          'youtube': 'https://www.youtube.com/watch?v=n3kNlFMXslo',
          'article':
              'https://www.ted.com/talks/laura_vanderkam_how_to_gain_control_of_your_free_time',
        },
      ],
    },
    {
      'id': 'mindfulness',
      'title': 'Mindfulness & Calm',
      'emoji': '🧘',
      'description': 'Quieting an overactive mind',
      'color': const Color(0xFF174143),
      'talks': [
        {
          'title': 'All It Takes Is 10 Mindful Minutes',
          'speaker': 'Andy Puddicombe',
          'duration': '10 min',
          'description':
              'An accessible roadmap to doing nothing mindfully for a scattered mind.',
          'youtube': 'https://www.youtube.com/watch?v=qzR62JJCMBQ',
          'article':
              'https://www.ted.com/talks/andy_puddicombe_all_it_takes_is_10_mindful_minutes',
        },
        {
          'title': 'What You Practice Grows Stronger',
          'speaker': 'Shauna Shapiro',
          'duration': '16 min',
          'description':
              'Blending mindfulness with neuroplasticity and self-kindness.',
          'youtube': 'https://www.youtube.com/watch?v=IeblJdB2-Vo',
          'article':
              'https://www.ted.com/talks/shauna_shapiro_what_you_practice_grows_stronger',
        },
        {
          'title': 'A Simple Way to Break a Bad Habit',
          'speaker': 'Judson Brewer',
          'duration': '9 min',
          'description':
              'Using curiosity to stop anxiety-driven coping mechanisms.',
          'youtube': 'https://www.youtube.com/watch?v=-moW9jvvMr4',
          'article':
              'https://www.ted.com/talks/judson_brewer_a_simple_way_to_break_a_bad_habit',
        },
        {
          'title': 'How Meditation Can Reshape Your Brain',
          'speaker': 'Sara Lazar',
          'duration': '8 min',
          'description':
              'Hard data showing gray matter growth from meditation practice.',
          'youtube': 'https://www.youtube.com/watch?v=m8rRzTtP7Tc',
          'article':
              'https://www.ted.com/talks/sara_lazar_how_meditation_can_reshape_our_brains',
        },
        {
          'title': 'The Art of Stillness',
          'speaker': 'Pico Iyer',
          'duration': '15 min',
          'description':
              'Finding peace by sitting still in a digitally fatigued fast world.',
          'youtube': 'https://www.youtube.com/watch?v=XmansZGQHxY',
          'article': 'https://www.ted.com/talks/pico_iyer_the_art_of_stillness',
        },
        {
          'title': 'How to Calm Your Anxiety From a Neuroscientist',
          'speaker': 'Wendy Suzuki',
          'duration': '14 min',
          'description':
              'Immediate breathing and movement interventions for jittery minds.',
          'youtube': 'https://www.youtube.com/watch?v=MIr3RsUWrdo',
          'article':
              'https://www.ted.com/talks/wendy_suzuki_how_to_calm_your_anxiety_from_a_neuroscientist',
        },
        {
          'title': 'Self Transformation Through Mindfulness',
          'speaker': 'David Vago',
          'duration': '14 min',
          'description':
              'Structural changes in the brain via focused awareness.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNvago',
          'article':
              'https://www.ted.com/talks/david_vago_self_transformation_through_mindfulness',
        },
        {
          'title': 'Improving Your Daily Life with Mindfulness',
          'speaker': 'Jessica Kotik',
          'duration': '10 min',
          'description':
              'Incorporating micro meditation sessions into busy routines.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNkotik',
          'article':
              'https://www.ted.com/talks/jessica_kotik_improving_your_daily_life_with_mindfulness_meditation',
        },
        {
          'title': 'Quiet the Noise Soothe Your Soul',
          'speaker': 'Shannon Albarelli',
          'duration': '8 min',
          'description':
              'Using 8 minutes of meditation to ground your nervous system.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNshannon',
          'article':
              'https://www.ted.com/talks/shannon_albarelli_quiet_the_noise_soothe_your_soul',
        },
        {
          'title': 'The Brain Science and Benefits of ASMR',
          'speaker': 'Craig Richard',
          'duration': '13 min',
          'description':
              'Utilizing calming sounds to lower heart rates for high sensory stress.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNasmr',
          'article':
              'https://www.ted.com/talks/craig_richard_the_brain_science_and_benefits_of_asmr',
        },
      ],
    },
    {
      'id': 'depression',
      'title': 'Depression & Dark Periods',
      'emoji': '😔',
      'description': 'Deep sadness and recovering meaning',
      'color': const Color(0xFF2C3E50),
      'talks': [
        {
          'title': 'This Could Be Why You Are Depressed or Anxious',
          'speaker': 'Johann Hari',
          'duration': '20 min',
          'description':
              'Looking at societal disconnects vs pure brain chemistry in depression.',
          'youtube': 'https://www.youtube.com/watch?v=MB5IX-np5fE',
          'article':
              'https://www.ted.com/talks/johann_hari_this_could_be_why_you_re_depressed_or_anxious',
        },
        {
          'title': 'Depression the Secret We Share',
          'speaker': 'Andrew Solomon',
          'duration': '30 min',
          'description':
              'An eloquent validating deep-dive into the lived experience of depression.',
          'youtube': 'https://www.youtube.com/watch?v=OPxztSbAtb4',
          'article':
              'https://www.ted.com/talks/andrew_solomon_depression_the_secret_we_share',
        },
        {
          'title': 'Confessions of a Depressed Comic',
          'speaker': 'Kevin Breel',
          'duration': '11 min',
          'description':
              'The duality of living a successful life while struggling internally.',
          'youtube': 'https://www.youtube.com/watch?v=ORkb-3aAQJM',
          'article':
              'https://www.ted.com/talks/kevin_breel_confessions_of_a_depressed_comic',
        },
        {
          'title': 'The Depression Cure',
          'speaker': 'Stephen Ilardi',
          'duration': '22 min',
          'description':
              'An evolutionary approach involving diet light and movement.',
          'youtube': 'https://www.youtube.com/watch?v=drv3BP0Fdi8',
          'article':
              'https://www.ted.com/talks/stephen_ilardi_the_depression_cure',
        },
        {
          'title': 'Do not Suffer from Depression in Silence',
          'speaker': 'Nikki Webber Allen',
          'duration': '10 min',
          'description': 'Tackling the cultural stigma of mental illness.',
          'youtube': 'https://www.youtube.com/watch?v=jHx-HgAWLog',
          'article':
              'https://www.ted.com/talks/nikki_webber_allen_don_t_suffer_from_depression_in_silence',
        },
        {
          'title': 'How to Connect with Depressed Friends',
          'speaker': 'Bill Bernat',
          'duration': '13 min',
          'description':
              'A humorous look at navigating relationships when feeling down.',
          'youtube': 'https://www.youtube.com/watch?v=9K8-b0cHetU',
          'article':
              'https://www.ted.com/talks/bill_bernat_how_to_connect_with_depressed_friends',
        },
        {
          'title': 'Mental Health for All by Involving All',
          'speaker': 'Vikram Patel',
          'duration': '14 min',
          'description': 'How communities can heal together when overwhelmed.',
          'youtube': 'https://www.youtube.com/watch?v=tRak7_tYuqE',
          'article':
              'https://www.ted.com/talks/vikram_patel_mental_health_for_all_by_involving_all',
        },
        {
          'title': 'Mental Health Disorders and the Hope for Happiness',
          'speaker': 'Lilly OShaughnessy',
          'duration': '11 min',
          'description':
              'A focus on constructive psychology and reducing self-stigma.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNlilly',
          'article':
              'https://www.ted.com/talks/lilly_o_shaughnessy_mental_health_disorders_and_the_hope_for_happiness',
        },
        {
          'title': 'Why You Should Talk About Anxiety at Work',
          'speaker': 'Adam Whybrew',
          'duration': '10 min',
          'description':
              'Breaking barriers regarding professional performance while struggling.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNadam',
          'article':
              'https://www.ted.com/talks/adam_whybrew_why_you_should_talk_about_your_anxiety_at_work',
        },
        {
          'title': 'How Electroshock Therapy Changed Me',
          'speaker': 'Sherwin Nuland',
          'duration': '19 min',
          'description':
              'A powerful look at medical intervention and hope for treatment-resistant depression.',
          'youtube': 'https://www.youtube.com/watch?v=WClEXH4NkFo',
          'article':
              'https://www.ted.com/talks/sherwin_nuland_the_electroshock_cure_for_depression',
        },
      ],
    },
    {
      'id': 'emotional',
      'title': 'Emotional Intelligence',
      'emoji': '💭',
      'description': 'Managing emotions and mood swings',
      'color': const Color(0xFF6B2D8B),
      'talks': [
        {
          'title': 'The Gift and Power of Emotional Courage',
          'speaker': 'Susan David',
          'duration': '16 min',
          'description':
              'Why forcing positive thinking can backfire when suppressing emotions.',
          'youtube': 'https://www.youtube.com/watch?v=NDQ1Mi5I4rg',
          'article':
              'https://www.ted.com/talks/susan_david_the_gift_and_power_of_emotional_courage',
        },
        {
          'title': 'You Are Not at the Mercy of Your Emotions',
          'speaker': 'Lisa Feldman Barrett',
          'duration': '18 min',
          'description':
              'A neuroscience view of how to re-architect your feelings.',
          'youtube': 'https://www.youtube.com/watch?v=0gks6ceq4eQ',
          'article':
              'https://www.ted.com/talks/lisa_feldman_barrett_you_aren_t_at_the_mercy_of_your_emotions_your_brain_creates_them',
        },
        {
          'title': 'Why We All Need to Practice Emotional First Aid',
          'speaker': 'Guy Winch',
          'duration': '17 min',
          'description':
              'Treating psychological wounds with standard mental hygiene.',
          'youtube': 'https://www.youtube.com/watch?v=F2hc2FLOdhI',
          'article':
              'https://www.ted.com/talks/guy_winch_the_case_for_emotional_hygiene',
        },
        {
          'title': 'Permission to Feel',
          'speaker': 'Marc Brackett',
          'duration': '16 min',
          'description':
              'The crisis of emotional illiteracy and how to name what hurts.',
          'youtube': 'https://www.youtube.com/watch?v=07R5MiEXn8A',
          'article':
              'https://www.ted.com/talks/marc_brackett_permission_to_feel',
        },
        {
          'title': 'Compassion and the True Meaning of Empathy',
          'speaker': 'Joan Halifax',
          'duration': '12 min',
          'description':
              'Avoiding taking on too much of others pain when experiencing empathetic distress.',
          'youtube': 'https://www.youtube.com/watch?v=vDHmDPbnsB4',
          'article':
              'https://www.ted.com/talks/joan_halifax_compassion_and_the_true_meaning_of_empathy',
        },
        {
          'title': 'The Art of Managing Emotions',
          'speaker': 'Daniel Goleman',
          'duration': '13 min',
          'description':
              'Emotional mastery in high-stakes environments for frustrated people.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNgoleman',
          'article':
              'https://www.ted.com/talks/daniel_goleman_the_art_of_managing_emotions',
        },
        {
          'title': 'How to Embrace Emotions at Work',
          'speaker': 'Liz Fosslien',
          'duration': '13 min',
          'description':
              'Balancing professional boundaries with human feelings.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNliz',
          'article':
              'https://www.ted.com/talks/liz_fosslien_how_to_embrace_emotions_at_work',
        },
        {
          'title': '6 Steps to Improve Your Emotional Intelligence',
          'speaker': 'Ramona Hacker',
          'duration': '11 min',
          'description':
              'Concrete steps to identify what you are feeling when emotionally confused.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNramona',
          'article':
              'https://www.ted.com/talks/ramona_hacker_6_steps_to_improve_your_emotional_intelligence',
        },
        {
          'title': 'The Power of Emotional Intelligence',
          'speaker': 'Travis Bradberry',
          'duration': '14 min',
          'description':
              'Using behavioral shifts to elevate control when reactive.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNtravis',
          'article':
              'https://www.ted.com/talks/travis_bradberry_the_power_of_emotional_intelligence',
        },
        {
          'title': '5 Steps to Remove Yourself From Drama',
          'speaker': 'Anastasia Penright',
          'duration': '10 min',
          'description':
              'Protecting your inner peace from external toxicity when interpersonally exhausted.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNdrama',
          'article':
              'https://www.ted.com/talks/anastasia_penright_5_steps_to_remove_yourself_from_drama_at_work',
        },
      ],
    },
    {
      'id': 'resilience',
      'title': 'Resilience & Healing',
      'emoji': '💪',
      'description': 'Overcoming struggles and bouncing back',
      'color': const Color(0xFF1B6B6E),
      'talks': [
        {
          'title': 'The Power of Vulnerability',
          'speaker': 'Brené Brown',
          'duration': '20 min',
          'description':
              'Learning to accept imperfections as core connections.',
          'youtube': 'https://www.youtube.com/watch?v=iCvmsMzlF7o',
          'article':
              'https://www.ted.com/talks/brene_brown_the_power_of_vulnerability',
        },
        {
          'title': 'The Three Secrets of Resilient People',
          'speaker': 'Dr. Lucy Hone',
          'duration': '16 min',
          'description':
              'Dealing with sudden life disruptions when grieving or highly distressed.',
          'youtube': 'https://www.youtube.com/watch?v=NWH8N-BvhAw',
          'article':
              'https://www.ted.com/talks/lucy_hone_3_secrets_of_resilient_people',
        },
        {
          'title': 'The Happy Secret to Better Work',
          'speaker': 'Shawn Achor',
          'duration': '12 min',
          'description':
              'Happiness inspires us to be more productive and resilient.',
          'youtube': 'https://www.youtube.com/watch?v=fLJsdqxnZb0',
          'article':
              'https://www.ted.com/talks/shawn_achor_the_happy_secret_to_better_work',
        },
        {
          'title': 'How Changing Your Story Can Change Your Life',
          'speaker': 'Lori Gottlieb',
          'duration': '16 min',
          'description':
              'Rewriting internal narratives to break bad emotional loops.',
          'youtube': 'https://www.youtube.com/watch?v=O_MQr4lHm0c',
          'article':
              'https://www.ted.com/talks/lori_gottlieb_how_changing_your_story_can_change_your_life',
        },
        {
          'title': 'The Choice',
          'speaker': 'Edith Eger',
          'duration': '18 min',
          'description':
              'A Holocaust survivor lesson on how the mind can free itself from severe trauma.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNedith',
          'article': 'https://www.ted.com/talks/edith_eger_the_choice',
        },
        {
          'title': 'Resilience The Art of Failing Forward',
          'speaker': 'Sasha Shillcutt',
          'duration': '13 min',
          'description':
              'Normalizing a margin of failure for perfectionist stress.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNsasha',
          'article':
              'https://www.ted.com/talks/sasha_shillcutt_resilience_the_art_of_failing_forward',
        },
        {
          'title': 'There is No Shame in Taking Care of Your Mental Health',
          'speaker': 'Sangu Delle',
          'duration': '12 min',
          'description': 'Undoing the stigma that seeking help makes you weak.',
          'youtube': 'https://www.youtube.com/watch?v=hjG3HHBSEoE',
          'article':
              'https://www.ted.com/talks/sangu_delle_there_s_no_shame_in_taking_care_of_your_mental_health',
        },
        {
          'title': 'I Will Not Die an Unlived Life',
          'speaker': 'Dawna Markova',
          'duration': '11 min',
          'description':
              'Finding individual purpose when feeling invisible and existentially lonely.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNdawna',
          'article':
              'https://www.ted.com/talks/dawna_markova_i_will_not_die_an_unlived_life',
        },
        {
          'title': 'The Path to Resilience',
          'speaker': 'Stephen Sideroff',
          'duration': '14 min',
          'description':
              'Re-establishing physical safety parameters for rigid mental states.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNstephen',
          'article':
              'https://www.ted.com/talks/stephen_sideroff_the_path_to_resilience',
        },
        {
          'title': 'The 3 As of Awesome',
          'speaker': 'Neil Pasricha',
          'duration': '17 min',
          'description':
              'A simple framework for daily gratitude and sensory awareness.',
          'youtube': 'https://www.youtube.com/watch?v=fxMvgRvsIFo',
          'article':
              'https://www.ted.com/talks/neil_pasricha_the_3_a_s_of_awesome',
        },
      ],
    },
    {
      'id': 'connection',
      'title': 'Loneliness & Connection',
      'emoji': '🤝',
      'description': 'Overcoming loneliness and fear of judgment',
      'color': const Color(0xFF174143),
      'talks': [
        {
          'title': 'What Makes a Good Life',
          'speaker': 'Robert Waldinger',
          'duration': '12 min',
          'description':
              'Empirical proof that relationships stave off mental decline.',
          'youtube': 'https://www.youtube.com/watch?v=8KkKuTCFvzI',
          'article':
              'https://www.ted.com/talks/robert_waldinger_what_makes_a_good_life_lessons_from_the_longest_study_on_happiness',
        },
        {
          'title': 'The Surprising Benefits of Talking to Strangers',
          'speaker': 'Gillian Sandstrom',
          'duration': '14 min',
          'description':
              'Micro-connections that elevate baseline dopamine for socially anxious people.',
          'youtube': 'https://www.youtube.com/watch?v=JHbKOoFBOAM',
          'article':
              'https://www.ted.com/talks/gillian_sandstrom_the_surprising_benefits_of_talking_to_strangers',
        },
        {
          'title': 'The Power of Introverts',
          'speaker': 'Susan Cain',
          'duration': '19 min',
          'description':
              'Validating the deep need for quiet spaces in a loud world.',
          'youtube': 'https://www.youtube.com/watch?v=c0KYU2j0TM4',
          'article':
              'https://www.ted.com/talks/susan_cain_the_power_of_introverts',
        },
        {
          'title': 'We Need to Talk About Adult Loneliness',
          'speaker': 'Kat Vellos',
          'duration': '13 min',
          'description':
              'Actionable blueprints to form genuine adult friendships.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNkat',
          'article':
              'https://www.ted.com/talks/kat_vellos_we_need_to_talk_about_adult_loneliness',
        },
        {
          'title': 'You Are Not Alone in Your Loneliness',
          'speaker': 'Jonny Sun',
          'duration': '10 min',
          'description':
              'Finding safe spaces online and offline for shared sadness.',
          'youtube': 'https://www.youtube.com/watch?v=cPMLqmOCQes',
          'article':
              'https://www.ted.com/talks/jonny_sun_you_are_not_alone_in_your_loneliness',
        },
        {
          'title': 'The Anatomy of Trust',
          'speaker': 'Brené Brown',
          'duration': '23 min',
          'description':
              'Breaking down the small moments that build safe relationships.',
          'youtube': 'https://www.youtube.com/watch?v=q-_rJWEsYpg',
          'article':
              'https://www.ted.com/talks/brene_brown_the_anatomy_of_trust',
        },
        {
          'title': 'How You Can Use Impostor Syndrome to Your Benefit',
          'speaker': 'Mike Cannon-Brookes',
          'duration': '11 min',
          'description':
              'Managing workplace or social performance anxiety and fraud feelings.',
          'youtube': 'https://www.youtube.com/watch?v=ZkwqZFvbdFc',
          'article':
              'https://www.ted.com/talks/mike_cannon_brookes_how_you_can_use_impostor_syndrome_to_your_benefit',
        },
        {
          'title': 'The Secret to Expanding Your Social Network',
          'speaker': 'Tanya Menon',
          'duration': '15 min',
          'description':
              'Getting out of protective mental ruts when feeling stagnant.',
          'youtube': 'https://www.youtube.com/watch?v=j9_yN8xSxS8',
          'article':
              'https://www.ted.com/talks/tanya_menon_the_secret_to_great_opportunities_the_person_you_haven_t_met_yet',
        },
        {
          'title': '5 Ways to Create Stronger Connections',
          'speaker': 'Robert Reffkin',
          'duration': '10 min',
          'description':
              'Deliberate steps toward vulnerable communication when socially detached.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNreffkin',
          'article':
              'https://www.ted.com/talks/robert_reffkin_5_ways_to_create_stronger_connections',
        },
        {
          'title': 'The Power of Ritual',
          'speaker': 'Casper ter Kuile',
          'duration': '12 min',
          'description':
              'Using community rituals to reduce chronic secular loneliness.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNritual',
          'article':
              'https://www.ted.com/talks/casper_ter_kuile_how_ritual_connects_us',
        },
      ],
    },
    {
      'id': 'neurodiversity',
      'title': 'Neurodiversity',
      'emoji': '🧠',
      'description': 'Navigating ADHD, OCD, Autism and more',
      'color': const Color(0xFF4A235A),
      'talks': [
        {
          'title': 'This is What It is Really Like to Live with ADHD',
          'speaker': 'Jessica McCabe',
          'duration': '13 min',
          'description':
              'Understanding executive dysfunction without shame for mentally chaotic minds.',
          'youtube': 'https://www.youtube.com/watch?v=xMWtGozn5jU',
          'article':
              'https://www.ted.com/talks/jessica_mccabe_this_is_what_it_s_really_like_to_live_with_adhd',
        },
        {
          'title': 'Failing at Normal',
          'speaker': 'Jessica McCabe',
          'duration': '11 min',
          'description':
              'Navigating a world not built for neurodivergent brains.',
          'youtube': 'https://www.youtube.com/watch?v=JiwZQNYlGQI',
          'article':
              'https://www.ted.com/talks/jessica_mccabe_failing_at_normal_an_adhd_success_story',
        },
        {
          'title': 'What It is Really Like to be Autistic',
          'speaker': 'Ethan Lisi',
          'duration': '10 min',
          'description':
              'Busting common myths about sensory overloads for socially anxious people.',
          'youtube': 'https://www.youtube.com/watch?v=eFpCzcCHH84',
          'article':
              'https://www.ted.com/talks/ethan_lisi_what_it_s_really_like_to_be_autistic',
        },
        {
          'title': 'Inside the Autistic Mind',
          'speaker': 'Rose Blackburn',
          'duration': '14 min',
          'description':
              'Masking behaviors and autistic burnout for overstimulated isolated people.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNrose',
          'article':
              'https://www.ted.com/talks/rose_blackburn_inside_the_autistic_mind',
        },
        {
          'title': 'What is Bipolar Disorder',
          'speaker': 'Dr. Helen M. Farrell',
          'duration': '5 min',
          'description':
              'A concise breakdown of structural mania and depression.',
          'youtube': 'https://www.youtube.com/watch?v=RrWBhVlD1H8',
          'article':
              'https://www.ted.com/talks/helen_m_farrell_what_is_bipolar_disorder',
        },
        {
          'title': 'ADHD as a Variable Attention Stimulus',
          'speaker': 'Edward Hallowell',
          'duration': '13 min',
          'description':
              'Reframing attention deficit as a race car brain with bicycle brakes.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNhallowell',
          'article':
              'https://www.ted.com/talks/edward_hallowell_adhd_as_a_difference_in_cognition_not_a_disorder',
        },
        {
          'title': 'Living with OCD',
          'speaker': 'Samantha Pena',
          'duration': '11 min',
          'description': 'Detailing the reality of OCD beyond tidiness trends.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNocd',
          'article': 'https://www.ted.com/talks/samantha_pena_living_with_ocd',
        },
        {
          'title': 'Demystifying Schizophrenia',
          'speaker': 'Aneesa Shariff',
          'duration': '12 min',
          'description':
              'Breaking down reality testing and clinical empathy for severe disorientation.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNschizo',
          'article':
              'https://www.ted.com/talks/aneesa_shariff_demystifying_schizophrenia',
        },
        {
          'title': 'The Autism Spectrum From the Inside Out',
          'speaker': 'Stephen Shore',
          'duration': '13 min',
          'description':
              'Leveraging neurodivergent strengths for socially disconnected people.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNshore',
          'article':
              'https://www.ted.com/talks/stephen_shore_the_autism_spectrum_from_the_inside_out',
        },
        {
          'title': 'Everything You Think You Know About Addiction is Wrong',
          'speaker': 'Johann Hari',
          'duration': '14 min',
          'description':
              'Surprising insights about the real causes of addiction and recovery.',
          'youtube': 'https://www.youtube.com/watch?v=PY9DcIMGxMs',
          'article':
              'https://www.ted.com/talks/johann_hari_everything_you_think_you_know_about_addiction_is_wrong',
        },
      ],
    },
    {
      'id': 'shame',
      'title': 'Shame & Trauma',
      'emoji': '😔',
      'description': 'Healing deep wounds and perfectionism',
      'color': const Color(0xFF7B241C),
      'talks': [
        {
          'title': 'Listening to Shame',
          'speaker': 'Brené Brown',
          'duration': '20 min',
          'description':
              'Distinguishing between I did bad and I am bad when paralyzed by guilt.',
          'youtube': 'https://www.youtube.com/watch?v=psN1DORYYV0',
          'article': 'https://www.ted.com/talks/brene_brown_listening_to_shame',
        },
        {
          'title': 'How Childhood Trauma Affects Health Across a Lifetime',
          'speaker': 'Dr. Nadine Burke Harris',
          'duration': '16 min',
          'description':
              'How past adversity impacts current stress systems for adult trauma survivors.',
          'youtube': 'https://www.youtube.com/watch?v=95ovIJ3dsNk',
          'article':
              'https://www.ted.com/talks/nadine_burke_harris_how_childhood_trauma_affects_health_across_a_lifetime',
        },
        {
          'title': 'The Voices in My Head',
          'speaker': 'Eleanor Longden',
          'duration': '14 min',
          'description':
              'Shifting from what is wrong with you to what happened to you.',
          'youtube': 'https://www.youtube.com/watch?v=syjEN3peCJw',
          'article':
              'https://www.ted.com/talks/eleanor_longden_the_voices_in_my_head',
        },
        {
          'title': 'The Space Between Self Esteem and Self Compassion',
          'speaker': 'Dr. Kristin Neff',
          'duration': '19 min',
          'description':
              'Why self-kindness outlasts competitive performance for perfectionists.',
          'youtube': 'https://www.youtube.com/watch?v=IvtZBUSplr4',
          'article':
              'https://www.ted.com/talks/kristin_neff_the_space_between_self_esteem_and_self_compassion',
        },
        {
          'title': 'How to Connect with Depressed Friends',
          'speaker': 'Bill Bernat',
          'duration': '13 min',
          'description':
              'Navigating relationships with humor when feeling deeply down.',
          'youtube': 'https://www.youtube.com/watch?v=9K8-b0cHetU',
          'article':
              'https://www.ted.com/talks/bill_bernat_how_to_connect_with_depressed_friends',
        },
        {
          'title': 'There is No Shame in Taking Care of Your Mental Health',
          'speaker': 'Sangu Delle',
          'duration': '12 min',
          'description':
              'Undoing the specific stigma that seeking help makes you weak.',
          'youtube': 'https://www.youtube.com/watch?v=hjG3HHBSEoE',
          'article':
              'https://www.ted.com/talks/sangu_delle_there_s_no_shame_in_taking_care_of_your_mental_health',
        },
        {
          'title': 'The Choice',
          'speaker': 'Edith Eger',
          'duration': '18 min',
          'description':
              'A Holocaust survivor lesson on how the mind can free itself.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNedith',
          'article': 'https://www.ted.com/talks/edith_eger_the_choice',
        },
        {
          'title': 'Change Your Mindset Change Your Game',
          'speaker': 'Alia Crum',
          'duration': '15 min',
          'description':
              'How structural beliefs completely dictate physical outcomes.',
          'youtube': 'https://www.youtube.com/watch?v=0tqq66zwa7g',
          'article':
              'https://www.ted.com/talks/alia_crum_change_your_mindset_change_your_game',
        },
        {
          'title': 'Self Reg Shifting from Behavior to Stress',
          'speaker': 'Stuart Shanker',
          'duration': '14 min',
          'description':
              'Recognizing that bad behavior is usually unmanaged stress.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNshanker',
          'article':
              'https://www.ted.com/talks/stuart_shanker_self_reg_shifting_from_behavior_to_stress',
        },
        {
          'title': 'How to Outsmart Stress',
          'speaker': 'Dr. Mithu Storoni',
          'duration': '13 min',
          'description':
              'Small physiological interventions to protect brain cells from acute daily stress.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNmithu',
          'article':
              'https://www.ted.com/talks/mithu_storoni_how_to_outsmart_stress',
        },
      ],
    },
    {
      'id': 'coping',
      'title': 'Daily Coping & Physical Health',
      'emoji': '🏃',
      'description': 'Body-first tactics to lower stress',
      'color': const Color(0xFF1A5276),
      'talks': [
        {
          'title': 'The Brain Changing Benefits of Exercise',
          'speaker': 'Wendy Suzuki',
          'duration': '13 min',
          'description':
              'Using physical movement as an immediate mood elevator.',
          'youtube': 'https://www.youtube.com/watch?v=BHY0FxzoKZE',
          'article':
              'https://www.ted.com/talks/wendy_suzuki_the_brain_changing_benefits_of_exercise',
        },
        {
          'title': 'Sleep is Your Superpower',
          'speaker': 'Matthew Walker',
          'duration': '19 min',
          'description':
              'How poor sleep erases emotional regulation for sleep-deprived anxious people.',
          'youtube': 'https://www.youtube.com/watch?v=5MuIMqhT8oM',
          'article':
              'https://www.ted.com/talks/matt_walker_sleep_is_your_superpower',
        },
        {
          'title': 'Your Body Language May Shape Who You Are',
          'speaker': 'Amy Cuddy',
          'duration': '21 min',
          'description':
              'Altering physiology through power posing to impact hormone levels.',
          'youtube': 'https://www.youtube.com/watch?v=Ks-_Mh1QhMc',
          'article':
              'https://www.ted.com/talks/amy_cuddy_your_body_language_may_shape_who_you_are',
        },
        {
          'title': 'How What You Eat Affects Your Mental Health',
          'speaker': 'Kimberley Wilson',
          'duration': '14 min',
          'description':
              'Investigating the brain-gut connection for chronic low mood.',
          'youtube': 'https://www.youtube.com/watch?v=3sA0UWSk5po',
          'article':
              'https://www.ted.com/talks/kimberley_wilson_how_what_you_eat_affects_your_mental_health',
        },
        {
          'title': 'How to Feed Your Brain',
          'speaker': 'Max Lugavere',
          'duration': '15 min',
          'description':
              'Addressing the physical nutrition components of high stress and brain fog.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNmax',
          'article':
              'https://www.ted.com/talks/max_lugavere_how_to_feed_your_brain',
        },
        {
          'title': 'Move The New Science of Body Over Mind',
          'speaker': 'Caroline Williams',
          'duration': '13 min',
          'description': 'Using posture and stride to shift mental anxiety.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNcaroline',
          'article':
              'https://www.ted.com/talks/caroline_williams_move_the_new_science_of_body_over_mind',
        },
        {
          'title': 'The Polyvagal Theory',
          'speaker': 'Stephen Porges',
          'duration': '16 min',
          'description':
              'Understanding how to trigger your parasympathetic nervous system.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNporges',
          'article':
              'https://www.ted.com/talks/stephen_porges_the_polyvagal_theory',
        },
        {
          'title': 'The Health Benefits of Clowning Around',
          'speaker': 'Matthew A. Wilson',
          'duration': '11 min',
          'description':
              'Using play and lightness to discharge adrenaline for rigid hyper-stressed people.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNclown',
          'article':
              'https://www.ted.com/talks/matthew_a_wilson_the_health_benefits_of_clowning_around',
        },
        {
          'title': 'The Sharp Brain',
          'speaker': 'Heidi Hanna',
          'duration': '14 min',
          'description':
              'Shifting stress from a threat to a challenge signal for mentally fatigued people.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNheidi',
          'article': 'https://www.ted.com/talks/heidi_hanna_the_sharp_brain',
        },
        {
          'title': 'How to Benefit from Stress',
          'speaker': 'Modupe Akinola',
          'duration': '12 min',
          'description':
              'Practical tips for optimizing adrenaline in high-stakes environments.',
          'youtube': 'https://www.youtube.com/watch?v=4EaNmodupe',
          'article':
              'https://www.ted.com/talks/modupe_akinola_how_to_benefit_from_stress',
        },
      ],
    },
  ];

  String? selectedCategoryId;

  List<Map<String, dynamic>> get selectedTalks {
    if (selectedCategoryId == null) return [];
    final category = categories.firstWhere(
      (c) => c['id'] == selectedCategoryId,
      orElse: () => {},
    );
    return category.isEmpty
        ? []
        : List<Map<String, dynamic>>.from(category['talks']);
  }

  Map<String, dynamic>? get selectedCategory {
    if (selectedCategoryId == null) return null;
    return categories.firstWhere(
      (c) => c['id'] == selectedCategoryId,
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF174143),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'TED',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Talks for Mental Health',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: selectedCategoryId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedCategoryId = null),
              )
            : null,
      ),
      body: selectedCategoryId == null
          ? _buildCategoriesView()
          : _buildTalksView(),
    );
  }

  Widget _buildCategoriesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF174143),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Select a category that matches how you feel right now. Each talk can be watched on YouTube or read as an article.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'How are you feeling?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose a category to find helpful TED talks',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () =>
                    setState(() => selectedCategoryId = category['id']),
                child: Container(
                  decoration: BoxDecoration(
                    color: category['color'] as Color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category['emoji'],
                        style: const TextStyle(fontSize: 28),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '10 talks',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTalksView() {
    final category = selectedCategory!;
    final talks = selectedTalks;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: talks.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: category['color'] as Color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(category['emoji'], style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        category['description'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        final talk = talks[index - 1];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: (category['color'] as Color).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'TED',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            talk['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            talk['speaker'],
                            style: TextStyle(
                              color: category['color'] as Color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            talk['duration'],
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talk['description'],
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Opening YouTube: ${talk['title']}',
                                  ),
                                  backgroundColor: category['color'] as Color,
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_circle, size: 16),
                            label: const Text('Watch'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: category['color'] as Color,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Opening Article: ${talk['title']}',
                                  ),
                                  backgroundColor: category['color'] as Color,
                                ),
                              );
                            },
                            icon: const Icon(Icons.article, size: 16),
                            label: const Text('Read'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: category['color'] as Color,
                              side: BorderSide(
                                color: category['color'] as Color,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
