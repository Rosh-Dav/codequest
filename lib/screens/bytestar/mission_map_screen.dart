import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/bytestar_theme.dart';
import '../../models/bytestar_data.dart';
import '../../models/bytestar_data.dart';
import '../../widgets/bytestar/nova_hologram.dart';
import '../../widgets/bytestar/animated_space_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mission_engine_screen.dart';
import '../bytestar/profile_screen.dart';

class MissionMapScreen extends StatefulWidget {
  final String username;

  const MissionMapScreen({super.key, required this.username});

  @override
  State<MissionMapScreen> createState() => _MissionMapScreenState();
}

class _MissionMapScreenState extends State<MissionMapScreen> {
  // Dummy missions for now
  final List<Mission> missions = [
    Mission(
      id: 'm1',
      title: 'Wake Up ASTRA-X',
      description: 'Initialize the main communication mainframe.',
      concept: 'Program Structure',
      introVideoId: 'm1_intro',
      openingScene: SceneType.darkSpaceship,
      dialogueLines: [
        'System Initialization failure...',
        'Cadet, I am NOVA, the ship\'s AI. My core mainframe is offline.',
        'To repair the ship, we must speak the language of its systems: C.',
        'Every system program needs a startup structure to function.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: '#include <stdio.h>\n\nint main() {\n    return 0;\n}',
        steps: [
          TeachingStep(
            explanation: '#include <stdio.h> is like loading your repair toolbox.',
            highlightedLines: [1],
            visualAssetId: 'tool_loading',
          ),
          TeachingStep(
            explanation: 'int main() is the engine start button. Instructions go between { and }.',
            highlightedLines: [3],
            visualAssetId: 'engine_start',
          ),
          TeachingStep(
            explanation: 'return 0; is the success signal. It tells the ship the startup worked!',
            highlightedLines: [4],
            visualAssetId: 'success_signal',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Complete the startup sequence by adding the missing main function.',
        initialCode: '#include <stdio.h>\n\n// Start engine here\n',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'int main', errorMessage: 'We need the main engine: "int main()"'),
          ValidationRule(pattern: '{', errorMessage: 'Don\'t forget the opening brace {'),
          ValidationRule(pattern: '}', errorMessage: 'Close the instruction container with }'),
          ValidationRule(pattern: 'return 0', errorMessage: 'Signal success with "return 0;"'),
          ValidationRule(pattern: ';', errorMessage: 'Every command ends with a semicolon ;'),
        ],
        hints: ['int main() { return 0; }'],
      ),
      isLocked: false,
      x: 0.2,
      y: 0.9,
    ),
    Mission(
      id: 'm2',
      title: 'Stabilize Power Core',
      description: 'Stabilize the energy core variables.',
      concept: 'Variables',
      introVideoId: 'm2_intro',
      openingScene: SceneType.energyCore,
      dialogueLines: [
        'The primary ignition worked, but the power core is flickering!',
        'We need to store the power level in a temporary memory container.',
        'In C, these containers are called Variables.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int core_power = 100;\ncore_power = 250;',
        steps: [
          TeachingStep(
            explanation: '"int" tells the system this container holds whole numbers.',
            highlightedLines: [1],
            visualAssetId: 'variable_container',
          ),
          TeachingStep(
            explanation: 'We give it a name like "core_power" so we can find it later.',
            highlightedLines: [1],
            visualAssetId: 'variable_label',
          ),
          TeachingStep(
            explanation: 'We can update its value anytime as power levels fluctuate.',
            highlightedLines: [2],
            visualAssetId: 'value_update',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create an integer variable named "power" and assign it 100. Then on the next line, update it to 500.',
        initialCode: 'int main() {\n    // Create and update power here\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'int power = 100', errorMessage: 'First, create: int power = 100;'),
          ValidationRule(pattern: 'power = 500', errorMessage: 'Then update it: power = 500;'),
        ],
        hints: ['int power = 100; power = 500;'],
      ),
      x: 0.5,
      y: 0.85,
    ),
    Mission(
      id: 'm3',
      title: 'Protected Command System',
      description: 'Restore ship control room keywords.',
      concept: 'Keywords',
      introVideoId: 'm3_intro',
      openingScene: SceneType.commandSystem,
      dialogueLines: [
        'Power is back! But the command terminal is rejecting our inputs.',
        'Certain words are "Reserved" by the system and cannot be used for names.',
        'These Keywords are like protected system keys.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int age; // Valid\nint if;  // ERROR! "if" is a keyword.',
        steps: [
          TeachingStep(
            explanation: 'Keywords like "int", "return", "if", and "while" are built-in commands.',
            highlightedLines: [2],
            visualAssetId: 'key_lock',
          ),
          TeachingStep(
            explanation: 'You can see them highlighted in different colors in your editor.',
            highlightedLines: [1, 2],
            visualAssetId: 'syntax_highlight',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'The generator is failing because of a keyword error. Rename the variable "float" to "fuel_level".',
        initialCode: 'int main() {\n    int float = 75; // Fix this line\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'fuel_level', errorMessage: 'Rename the variable to "fuel_level".'),
          ValidationRule(pattern: 'float', errorMessage: 'You must remove the word "float" as a name.', isMustContain: false),
        ],
        hints: ['int fuel_level = 75;'],
      ),
      x: 0.8,
      y: 0.8,
    ),
    Mission(
      id: 'm4',
      title: 'Signal Decoder System',
      description: 'Decode the incoming signals using correct data types.',
      concept: 'Data Types',
      introVideoId: 'm4_intro',
      openingScene: SceneType.signalRoom,
      dialogueLines: [
        'We are receiving fragmented distress signals.',
        'Signals come in different shapes: numbers, decimals, and text.',
        'We must use specific Data Types to store them correctly.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int count = 5;\nfloat frequency = 98.4;\nchar code = \'A\';',
        steps: [
          TeachingStep(
            explanation: '"int" is for whole numbers (integers).',
            highlightedLines: [1],
            visualAssetId: 'int_bin',
          ),
          TeachingStep(
            explanation: '"float" handles decimal point signals.',
            highlightedLines: [2],
            visualAssetId: 'float_bin',
          ),
          TeachingStep(
            explanation: '"char" stores single characters inside single quotes.',
            highlightedLines: [3],
            visualAssetId: 'char_bin',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Assign the frequency 104.7 to a float named "signal" and store the character \'Q\' in a char named "key".',
        initialCode: 'int main() {\n    // Type your code here\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'float signal = 104.7', errorMessage: 'Declare: float signal = 104.7;'),
          ValidationRule(pattern: "char key = 'Q'", errorMessage: 'Declare: char key = \'Q\';'),
        ],
        hints: ["float signal = 104.7; char key = 'Q';"],
      ),
      x: 0.7,
      y: 0.7,
    ),
    Mission(
      id: 'm5',
      title: 'Activate Display Panels',
      description: 'Format the engine status display.',
      concept: 'Output System',
      introVideoId: 'm5_intro',
      openingScene: SceneType.displayPanels,
      dialogueLines: [
        'Systems are running, but the bridge viewscreens are dark.',
        'We need to translate raw data into readable holographic text.',
        'The printf function is our primary communication translator.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int oxy = 95;\nprintf("Oxygen: %d%%", oxy);',
        steps: [
          TeachingStep(
            explanation: '%d is a placeholder marker for an integer.',
            highlightedLines: [2],
            visualAssetId: 'hologram_text',
          ),
          TeachingStep(
            explanation: 'The variable after the comma fills that marker.',
            highlightedLines: [2],
            visualAssetId: 'data_mapping',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Print the status code stored in the variable "code". The output should be: "Status: 7".',
        initialCode: 'int main() {\n    int code = 7;\n    // Print here\n    return 0;\n}',
        correctOutput: 'Status: 7',
        validationRules: [
          ValidationRule(pattern: 'printf', errorMessage: 'Use printf();'),
          ValidationRule(pattern: 'Status: %d', errorMessage: 'The text must be "Status: %d".'),
          ValidationRule(pattern: 'code', errorMessage: 'Don\'t forget to pass the "code" variable.'),
        ],
        hints: ['printf("Status: %d", code);'],
      ),
      x: 0.4,
      y: 0.65,
    ),
    Mission(
      id: 'm6',
      title: 'Restore Command Console',
      description: 'Restore ship response to pilot input.',
      concept: 'Input System',
      introVideoId: 'm6_intro',
      openingScene: SceneType.pilotConsole,
      dialogueLines: [
        'The pilot is trying to steer, but the ship isn\'t listening!',
        'We need to read commands from the command console sensors.',
        'In C, we use "scanf" to catch user input and store it.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int target;\nscanf("%d", &target);',
        steps: [
          TeachingStep(
            explanation: 'scanf waits for the pilot to enter a value.',
            highlightedLines: [2],
            visualAssetId: 'input_flash',
          ),
          TeachingStep(
            explanation: 'The & (address-of) symbol tells scanf exactly where to save that input.',
            highlightedLines: [2],
            visualAssetId: 'memory_address',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Read an integer from the pilot\'s console and store it in the variable named "heading".',
        initialCode: 'int main() {\n    int heading;\n    // Read input\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'scanf', errorMessage: 'Use scanf();'),
          ValidationRule(pattern: '&heading', errorMessage: 'Remember the "&" before the variable name.'),
          ValidationRule(pattern: '"%d"', errorMessage: 'Use "%d" for integer input.'),
        ],
        hints: ['scanf("%d", &heading);'],
      ),
      x: 0.1,
      y: 0.6,
    ),
    Mission(
      id: 'm7',
      title: 'Calculation Engine Repair',
      description: 'Fix the ship\'s faulty logic calculations.',
      concept: 'Operators',
      introVideoId: 'm7_intro',
      openingScene: SceneType.calculationCore,
      dialogueLines: [
        'The calculation core is producing massive errors!',
        'We need to perform precise math and logic to balance the ship.',
        'Operators like +, -, *, and / are the circuits of our logic.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int fuel = 10 + 20;\nbool ready = (fuel > 25);',
        steps: [
          TeachingStep(
            explanation: 'Arithmetic operators calculate values like fuel levels.',
            highlightedLines: [1],
            visualAssetId: 'math_circuit',
          ),
          TeachingStep(
            explanation: 'Comparison operators like > check if values meet safety limits.',
            highlightedLines: [2],
            visualAssetId: 'logic_gate',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Calculate the total fuel. Create a variable "total" that is "base" multiplied by 2.',
        initialCode: 'int main() {\n    int base = 50;\n    // Calculate total\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'int total = base * 2', errorMessage: 'Use: int total = base * 2;'),
          ValidationRule(pattern: '*', errorMessage: 'Use the "*" operator for multiplication.'),
        ],
        hints: ['int total = base * 2;'],
      ),
      x: 0.2,
      y: 0.5,
    ),
    Mission(
      id: 'm8',
      title: 'Decision AI System',
      description: 'Enable ship autopilot decision making.',
      concept: 'Conditions',
      introVideoId: 'm8_intro',
      openingScene: SceneType.autopilotAI,
      dialogueLines: [
        'Meteors ahead! The autopilot is frozen and can\'t choose a path.',
        'We need to give the ship a brain to make decisions.',
        'Conditional logic allows the ship to react to threats.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'if (threat < 10) {\n    printf("Safe");\n} else {\n    printf("Evade");\n}',
        steps: [
          TeachingStep(
            explanation: '"if" checks a condition. If it is true, the first block runs.',
            highlightedLines: [1, 2],
            visualAssetId: 'brain_logic',
          ),
          TeachingStep(
            explanation: '"else" is the fallback plan if the condition is false.',
            highlightedLines: [3, 4],
            visualAssetId: 'fallback_path',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Check if "temp" is above 100. If it is, print "Overheat". Otherwise, print "Stable".',
        initialCode: 'int main() {\n    int temp = 120;\n    // Write if-else here\n    return 0;\n}',
        correctOutput: 'Overheat',
        validationRules: [
          ValidationRule(pattern: 'if', errorMessage: 'Use an "if" statement.'),
          ValidationRule(pattern: 'else', errorMessage: 'Provide an "else" fallback.'),
          ValidationRule(pattern: 'Overheat', errorMessage: 'Print "Overheat" for high temp.'),
        ],
        hints: ['if(temp > 100) { printf("Overheat"); } else { ... }'],
      ),
      x: 0.5,
      y: 0.45,
    ),
    Mission(
      id: 'm9',
      title: 'Auto Navigation System',
      description: 'Automate repetitive thruster bursts.',
      concept: 'Loops',
      introVideoId: 'm9_intro',
      openingScene: SceneType.thrusterRoom,
      dialogueLines: [
        'Manual navigation is too slow for the asteroid belt.',
        'We need to pulse the thrusters repeatedly until we clear the zone.',
        'Loops allow us to automate repetitive ship tasks.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'for (int i = 0; i < 5; i++) {\n    printf("Burst!");\n}',
        steps: [
          TeachingStep(
            explanation: 'The counter "i" tracks how many times we have looped.',
            highlightedLines: [1],
            visualAssetId: 'loop_counter',
          ),
          TeachingStep(
            explanation: 'The middle part is the condition to keep going.',
            highlightedLines: [1],
            visualAssetId: 'orbit_viz',
          ),
          TeachingStep(
            explanation: 'i++ increases the counter every time.',
            highlightedLines: [1],
            visualAssetId: 'increment_flash',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Write a loop that prints "Align" exactly 3 times.',
        initialCode: 'int main() {\n    // Write for loop\n    return 0;\n}',
        correctOutput: 'AlignAlignAlign',
        validationRules: [
          ValidationRule(pattern: 'for', errorMessage: 'Use a "for" loop.'),
          ValidationRule(pattern: 'i < 3', errorMessage: 'The loop must run 3 times.'),
          ValidationRule(pattern: 'Align', errorMessage: 'Print "Align" inside the loop.'),
        ],
        hints: ['for(int i=0; i<3; i++) { printf("Align"); }'],
      ),
      x: 0.8,
      y: 0.4,
    ),
    Mission(
      id: 'm10',
      title: 'Command Router',
      description: 'Route signals through the command pathway.',
      concept: 'Switch Case',
      introVideoId: 'm10_intro',
      openingScene: SceneType.commandRouter,
      dialogueLines: [
        'Signals are flooding the switchboard!',
        'If we use too many if-else blocks, the routing becomes messy.',
        'Switch cases organize signals into fast, clear pathways.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'switch(sector) {\n    case 1: printf("North"); break;\n    case 2: printf("South"); break;\n}',
        steps: [
          TeachingStep(
            explanation: '"switch" looks at one variable and jumps to the matching "case".',
            highlightedLines: [1],
            visualAssetId: 'router_switch',
          ),
          TeachingStep(
            explanation: 'Never forget the "break"! It tells the signal to stop routing.',
            highlightedLines: [2, 3],
            visualAssetId: 'path_break',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create a switch for "mode". If mode is 1, print "Safe". If it is 2, print "Alert".',
        initialCode: 'int main() {\n    int mode = 2;\n    // Switch logic here\n    return 0;\n}',
        correctOutput: 'Alert',
        validationRules: [
          ValidationRule(pattern: 'switch', errorMessage: 'Use the "switch" keyword.'),
          ValidationRule(pattern: 'case 1', errorMessage: 'Add case 1: "Safe"'),
          ValidationRule(pattern: 'case 2', errorMessage: 'Add case 2: "Alert"'),
          ValidationRule(pattern: 'break', errorMessage: 'Each case needs a "break;".'),
        ],
        hints: ['switch(mode) { case 1: ...; break; ... }'],
      ),
      x: 0.7,
      y: 0.3,
    ),
    Mission(
      id: 'm11',
      title: 'Module Factory',
      description: 'Break code into reusable ship functions.',
      concept: 'Functions',
      introVideoId: 'm11_intro',
      openingScene: SceneType.moduleFactory,
      dialogueLines: [
        'The main code is becoming too heavy and overheating.',
        'We should package complex tasks into independent Modules.',
        'In C, we call these reusable modules "Functions".',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'void scan() {\n    printf("Scanning...");\n}\n\nint main() {\n    scan();\n}',
        steps: [
          TeachingStep(
            explanation: 'We define the function once outside of main.',
            highlightedLines: [1, 2, 3],
            visualAssetId: 'factory_blueprint',
          ),
          TeachingStep(
            explanation: 'We can call it by name as many times as we need.',
            highlightedLines: [6],
            visualAssetId: 'module_call',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create a function named "recharge" that prints "Charging". Call it inside main.',
        initialCode: '// Create function here\n\nint main() {\n    // Call function here\n    return 0;\n}',
        correctOutput: 'Charging',
        validationRules: [
          ValidationRule(pattern: 'void recharge', errorMessage: 'Define "void recharge() { ... }"'),
          ValidationRule(pattern: 'printf', errorMessage: 'The function should print "Charging".'),
          ValidationRule(pattern: 'recharge()', errorMessage: 'Call "recharge();" inside main.'),
        ],
        hints: ['void recharge() { printf("Charging"); }'],
      ),
      x: 0.4,
      y: 0.25,
    ),
    Mission(
      id: 'm12',
      title: 'Data Vault',
      description: 'Organize raw data into memory arrays.',
      concept: 'Arrays',
      introVideoId: 'm12_intro',
      openingScene: SceneType.dataVault,
      dialogueLines: [
        'Sensor data is scattered everywhere!',
        'Storing 100 readings in 100 variables is impossible.',
        'Arrays are like indexed storage lockers for grouped data.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int levels[3] = {10, 20, 30};\nint x = levels[0];',
        steps: [
          TeachingStep(
            explanation: 'The [3] tells the ship how many lockers to prepare.',
            highlightedLines: [1],
            visualAssetId: 'vault_locks',
          ),
          TeachingStep(
            explanation: 'We use indices starting at [0] to access specific lockers.',
            highlightedLines: [2],
            visualAssetId: 'indexed_access',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create an array of 2 integers named "vitals" with values 80 and 90.',
        initialCode: 'int main() {\n    // Create array here\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'int vitals[2]', errorMessage: 'Declare: int vitals[2]'),
          ValidationRule(pattern: '{80, 90}', errorMessage: 'Initialize with {80, 90};'),
        ],
        hints: ['int vitals[2] = {80, 90};'],
      ),
      x: 0.1,
      y: 0.2,
    ),
    Mission(
      id: 'm13',
      title: 'Memory Lab',
      description: 'Access ship memory using direct pointers.',
      concept: 'Pointers',
      introVideoId: 'm13_intro',
      openingScene: SceneType.memoryLab,
      dialogueLines: [
        'System memory is clogged with slow data copying.',
        'Pointers are laser beams that link directly to data locations.',
        'This allows us to modify data without moving it.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'int power = 100;\nint *p = &power;\n*p = 200;',
        steps: [
          TeachingStep(
            explanation: 'The "*" (star) creates a pointer, a variable that stores addresses.',
            highlightedLines: [2],
            visualAssetId: 'laser_link',
          ),
          TeachingStep(
            explanation: 'The "&" gets the address of our data container.',
            highlightedLines: [2],
            visualAssetId: 'address_flash',
          ),
          TeachingStep(
            explanation: 'Using *p again allows us to reach into the container and change it.',
            highlightedLines: [3],
            visualAssetId: 'remote_modify',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Create a pointer "ptr" that points to the variable "val".',
        initialCode: 'int main() {\n    int val = 5;\n    // Create pointer here\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'int *ptr', errorMessage: 'Declare: int *ptr'),
          ValidationRule(pattern: '&val', errorMessage: 'Assign it the address: ptr = &val;'),
        ],
        hints: ['int *ptr = &val;'],
      ),
      x: 0.2,
      y: 0.1,
    ),
    Mission(
      id: 'm14',
      title: 'Blueprint Lab',
      description: 'Model ship components using data structures.',
      concept: 'Structures',
      introVideoId: 'm14_intro',
      openingScene: SceneType.blueprintLab,
      dialogueLines: [
        'Final system sync! We need blueprints for complex objects.',
        'Structures (struct) allow us to group different data types into one entity.',
        'With blueprints, we can model everything from the engine to the crew.',
      ],
      teachingModule: const TeachingModule(
        codeSnippet: 'struct Ship {\n    int id;\n    float fuel;\n};\n\nstruct Ship astra;',
        steps: [
          TeachingStep(
            explanation: "struct defines the blueprint of a new object type.",
            highlightedLines: [1, 2, 3, 4],
            visualAssetId: 'blueprint_3d',
          ),
          TeachingStep(
            explanation: "Then we create instances of that object from the blueprint.",
            highlightedLines: [6],
            visualAssetId: 'object_spawn',
          ),
        ],
      ),
      task: const CodingTask(
        instruction: 'Complete the "Rover" structure. It needs an integer "id" and a float "battery".',
        initialCode: 'struct Rover {\n    // Add members here\n};\n\nint main() {\n    return 0;\n}',
        correctOutput: '',
        validationRules: [
          ValidationRule(pattern: 'int id', errorMessage: 'Add "int id;" member.'),
          ValidationRule(pattern: 'float battery', errorMessage: 'Add "float battery;" member.'),
        ],
        hints: ['struct Rover { int id; float battery; };'],
      ),
      x: 0.5,
      y: 0.05,
    ),
  ];

  Set<String> unlockedMissionIds = {'m1'}; // Default unlocked
  Set<String> completedMissionIds = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final unlocked = prefs.getStringList('unlockedMissions');
    final completed = prefs.getStringList('completedMissions');
    setState(() {
      if (unlocked != null) unlockedMissionIds = unlocked.toSet();
      if (completed != null) completedMissionIds = completed.toSet();
    });
  }

  Future<void> _unlockMission(String missionId) async {
    if (!unlockedMissionIds.contains(missionId)) {
      setState(() {
        unlockedMissionIds.add(missionId);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('unlockedMissions', unlockedMissionIds.toList());
    }
  }

  Future<void> _markCompleted(String missionId) async {
    if (!completedMissionIds.contains(missionId)) {
      setState(() {
        completedMissionIds.add(missionId);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('completedMissions', completedMissionIds.toList());
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByteStarTheme.primary,
      body: Stack(
        children: [
          // Background - Deep Space Grid (Dynamic)
           Positioned.fill(
            child: AnimatedSpaceBackground(
              sceneType: SceneType.deepSpace,
              child: const SizedBox.expand(),
            ),
          ),

          // Mission Paths (Connecting lines)
          CustomPaint(
            size: Size.infinite,
            painter: _MissionPathPainter(missions),
          ),

          // Mission Nodes
          ...missions.map((mission) {
            return Positioned(
              left: MediaQuery.of(context).size.width * mission.x - 30, // center offset
              top: MediaQuery.of(context).size.height * mission.y - 30,
              child: _MissionNode(
                mission: mission,
                isLocked: !unlockedMissionIds.contains(mission.id),
                onTap: () async {
                  if (unlockedMissionIds.contains(mission.id)) {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MissionEngineScreen(mission: mission),
                      ),
                    );
                    
                    if (result == true) {
                      // Mission Complete!
                      await _markCompleted(mission.id);
                      
                      // Unlock next in sequence
                      final currentIndex = missions.indexOf(mission);
                      if (currentIndex < missions.length - 1) {
                        _unlockMission(missions[currentIndex + 1].id);
                      }
                    }
                  }
                },
              ),
            );
          }),

          // HUD - Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Left Navigation
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: ByteStarTheme.accent),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        // User Info
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(username: widget.username),
                              ),
                            ).then((_) {
                              if (mounted) setState(() {});
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ByteStarTheme.secondary.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: ByteStarTheme.accent.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield, color: ByteStarTheme.accent, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Cadet ${widget.username}',
                                  style: ByteStarTheme.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ByteStarTheme.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.2, end: 0),
                    
                    // Ship Integrity / Mission Progress
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ByteStarTheme.secondary.withValues(alpha: 0.5),
                        border: Border.all(color: ByteStarTheme.success),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.battery_charging_full, color: ByteStarTheme.success, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Progress: ${completedMissionIds.length}/${missions.length}',
                            style: ByteStarTheme.body.copyWith(
                              color: ByteStarTheme.success,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // NOVA AI Assistant - Bottom Right
          Positioned(
            bottom: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                 // TODO: Show help/dialogue
              },
              child: const NovaHologram(size: 80),
            ).animate().slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.easeOutBack),
          ),
        ],
      ),
    );
  }
}

class _MissionNode extends StatelessWidget {
  final Mission mission;
  final VoidCallback onTap;
  final bool isLocked;

  const _MissionNode({
    required this.mission, 
    required this.onTap,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isLocked ? Colors.grey.withValues(alpha: 0.3) : ByteStarTheme.primary,
              border: Border.all(
                color: isLocked ? Colors.grey : ByteStarTheme.accent,
                width: 2,
              ),
              boxShadow: isLocked ? [] : [
                BoxShadow(
                  color: ByteStarTheme.accent.withValues(alpha: 0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock : (mission.icon ?? Icons.code),
                color: isLocked ? Colors.grey : ByteStarTheme.accent,
              ),
            ),
          ).animate(onPlay: (c) => isLocked ? null : c.repeat(reverse: true))
           .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 2.seconds),
          
          const SizedBox(height: 8),
          
          Text(
            mission.title,
            style: ByteStarTheme.body.copyWith(
              fontSize: 12,
              color: isLocked ? Colors.grey : ByteStarTheme.accent,
            ),
          ),
        ],
      ),
    );
  }
}


class _MissionPathPainter extends CustomPainter {
  final List<Mission> missions;

  _MissionPathPainter(this.missions);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ByteStarTheme.accent.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (missions.isNotEmpty) {
      final start = Offset(size.width * missions[0].x, size.height * missions[0].y);
      path.moveTo(start.dx, start.dy);
      
      for (int i = 1; i < missions.length; i++) {
        final p = Offset(size.width * missions[i].x, size.height * missions[i].y);
        path.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
