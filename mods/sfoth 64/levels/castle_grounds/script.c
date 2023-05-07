#include <ultra64.h>
#include "sm64.h"
#include "behavior_data.h"
#include "model_ids.h"
#include "seq_ids.h"
#include "dialog_ids.h"
#include "segment_symbols.h"
#include "level_commands.h"

#include "game/level_update.h"

#include "levels/scripts.h"


/* Fast64 begin persistent block [includes] */
/* Fast64 end persistent block [includes] */

#include "make_const_nonconst.h"
#include "levels/castle_grounds/header.h"

/* Fast64 begin persistent block [scripts] */
/* Fast64 end persistent block [scripts] */

const LevelScript level_castle_grounds_entry[] = {
	INIT_LEVEL(),
	LOAD_MIO0(0x7, _castle_grounds_segment_7SegmentRomStart, _castle_grounds_segment_7SegmentRomEnd), 
	LOAD_MIO0(0xa, _bitfs_skybox_mio0SegmentRomStart, _bitfs_skybox_mio0SegmentRomEnd), 
	ALLOC_LEVEL_POOL(),
	MARIO(MODEL_MARIO, 0x00000001, bhvMario),

	/* Fast64 begin persistent block [level commands] */
	/* Fast64 end persistent block [level commands] */

	LOAD_MODEL_FROM_GEO(MODEL_HEAVE_HO, heave_ho_geo),
	LOAD_MODEL_FROM_GEO(MODEL_LLL_TILTING_SQUARE_PLATFORM, lll_geo_000BF8),
	LOAD_MODEL_FROM_GEO(MODEL_EXCLAMATION_BOX, exclamation_box_geo),
	LOAD_MODEL_FROM_GEO(MODEL_HEART, heart_geo),
	LOAD_MODEL_FROM_GEO(MODEL_RED_FLAME, red_flame_geo),
	LOAD_MODEL_FROM_GEO(MODEL_WF_TUMBLING_BRIDGE, wf_geo_000AC8),
	LOAD_MODEL_FROM_GEO(MODEL_WF_TUMBLING_BRIDGE_PART, wf_geo_000AB0),
	LOAD_MODEL_FROM_GEO(MODEL_CANNON_BARREL, cannon_barrel_geo),
	LOAD_MODEL_FROM_GEO(MODEL_CANNON_BASE, cannon_base_geo),

	AREA(1, castle_grounds_area_1),
		WARP_NODE(0x0A, LEVEL_CASTLE_GROUNDS, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF0, LEVEL_CASTLE_GROUNDS, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF1, LEVEL_CASTLE_GROUNDS, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0x01, LEVEL_CASTLE_GROUNDS, 0x01, 0x02, WARP_NO_CHECKPOINT),
		WARP_NODE(0x02, LEVEL_CASTLE_GROUNDS, 0x01, 0x01, WARP_NO_CHECKPOINT),
		WARP_NODE(0x03, LEVEL_CASTLE_GROUNDS, 0x01, 0x04, WARP_NO_CHECKPOINT),
		WARP_NODE(0x04, LEVEL_CASTLE_GROUNDS, 0x01, 0x03, WARP_NO_CHECKPOINT),
		WARP_NODE(0x05, LEVEL_CASTLE_GROUNDS, 0x01, 0x06, WARP_NO_CHECKPOINT),
		WARP_NODE(0x06, LEVEL_CASTLE_GROUNDS, 0x01, 0x05, WARP_NO_CHECKPOINT),
		WARP_NODE(0x07, LEVEL_CASTLE_GROUNDS, 0x01, 0x08, WARP_NO_CHECKPOINT),
		WARP_NODE(0x08, LEVEL_CASTLE_GROUNDS, 0x01, 0x07, WARP_NO_CHECKPOINT),
		OBJECT(MODEL_NONE, 758, 1200, 683, 0, 0, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, -742, 1200, 683, 0, 0, 0, 0x00000010, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 758, 1200, -717, 0, 0, 0, 0x00000010, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, -742, 1200, -717, 0, 0, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, -3742, 2060, -4317, 0, 0, 0, 0x00000010, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, -3342, 2060, -4717, 0, 0, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, -42, 8960, 83, 0, 0, 0, 0x00000010, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 3758, 13460, 4683, 0, 0, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 4058, -2100, 5283, 0, 0, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 4058, -2100, 4583, 0, 0, 0, 0x00000010, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 9908, -5800, 3763, 0, 90, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 9508, -5800, 3763, 0, 90, 0, 0x00000010, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, -13342, 5270, 2483, 0, 0, 0, 0x00000001, id_bhvArenaSpawn),
		OBJECT(MODEL_NONE, 13, -3400, -927, 0, 0, 0, 0x00050000, bhvFadingWarp),
		OBJECT(MODEL_NONE, 293, 8890, -8457, 0, 0, 0, 0x00060000, bhvFadingWarp),
		OBJECT(MODEL_NONE, -5801, -4500, 6685, 0, 0, 0, (05 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, 5399, 300, 1785, 0, 0, 0, (05 << 24), id_bhvArenaItem),
		OBJECT(MODEL_WF_TUMBLING_BRIDGE, -42, 1000, 3583, 0, 0, 0, 0x00000000, bhvWfTumblingBridge),
		OBJECT(MODEL_CANNON_BASE, -4106, 2180, -5044, 0, -135, 0, 0x00000000, bhvCannon),
		OBJECT(MODEL_CANNON_BASE, -4386, -4370, 4986, 0, -45, 0, 0x00000000, bhvCannon),
		OBJECT(MODEL_NONE, 11199, -5700, 3785, 0, 0, 0, (04 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, 2758, 4000, 3083, 0, 0, 0, (06 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, -6392, 2000, -1967, 0, 0, 0, (06 << 24), id_bhvArenaItem),
		OBJECT(E_MODEL_LAUNCHPAD, -4651, -4559, 6904, 0, 0, 0, 0x00800000, id_bhvLaunchpad),
		OBJECT(E_MODEL_LAUNCHPAD, -5151, -2759, 6504, 0, 0, 0, 0x00600000, id_bhvLaunchpad),
		OBJECT(E_MODEL_LAUNCHPAD, -6051, -2159, 6004, 0, 0, 0, 0x00A00000, id_bhvLaunchpad),
		OBJECT(E_MODEL_LAUNCHPAD, -5551, -159, 6804, 0, 0, 0, 0x00800000, id_bhvLaunchpad),
		OBJECT(E_MODEL_LAUNCHPAD, -6051, 1841, 6504, 0, 0, 0, 0x00A00000, id_bhvLaunchpad),
		OBJECT(E_MODEL_LAUNCHPAD, -5851, 3841, 6904, 0, 0, 0, 0x00C00000, id_bhvLaunchpad),
		OBJECT(E_MODEL_LAUNCHPAD, 4969, -5879, 4244, 0, 0, 0, 0x00B00000, id_bhvLaunchpad),
		OBJECT(MODEL_RED_FLAME, 308, 1200, 7033, 0, -90, 0, 0x00000000, bhvFlamethrower),
		OBJECT(MODEL_RED_FLAME, 308, 1200, 7933, 0, -90, 0, 0x00000000, bhvFlamethrower),
		OBJECT(MODEL_RED_FLAME, -392, 1200, 7533, 0, 90, 0, 0x00000000, bhvFlamethrower),
		OBJECT(MODEL_RED_FLAME, 308, 1200, 8833, 0, -90, 0, 0x00000000, bhvFlamethrower),
		OBJECT(MODEL_RED_FLAME, -392, 1200, 8433, 0, 90, 0, 0x00000000, bhvFlamethrower),
		OBJECT(MODEL_RED_FLAME, -392, 1200, 6633, 0, 90, 0, 0x00000000, bhvFlamethrower),
		OBJECT(MODEL_WF_TUMBLING_BRIDGE, -42, 1000, 2283, 0, 0, 0, 0x00000000, bhvWfTumblingBridge),
		OBJECT(MODEL_WF_TUMBLING_BRIDGE, -42, 1000, 4983, 0, 0, 0, 0x00000000, bhvWfTumblingBridge),
		OBJECT(MODEL_NONE, -6742, 4100, -4317, 0, 0, 0, (03 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, 8, 1200, 9983, 0, 0, 0, (03 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, 2538, 12800, -8137, 0, 0, 0, (02 << 24), id_bhvArenaFlag),
		OBJECT(MODEL_NONE, -12, 1200, 13, 0, 0, 0, (00 << 24), id_bhvArenaFlag),
		OBJECT(MODEL_NONE, -6112, 7800, 7013, 0, 0, 0, (01 << 24), id_bhvArenaFlag),
		OBJECT(MODEL_NONE, 2499, 12800, -8615, 0, 0, 0, (02 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, -13801, 5400, 2485, 0, 0, 0, (02 << 24), id_bhvArenaItem),
		OBJECT(MODEL_HEART, -3772, 1440, 123, 0, 0, 0, 0x00010000, bhvRecoveryHeart),
		OBJECT(MODEL_HEART, 4028, 1210, 23, 0, 0, 0, 0x00010000, bhvRecoveryHeart),
		OBJECT(MODEL_NONE, -13342, 5270, 2483, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 8, 1130, -17, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 2508, 3870, 2983, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 3208, 8080, -3117, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 2508, 12690, -8137, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 8, 1090, 9863, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, -6132, 7710, 6953, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, -5812, -4590, 6353, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, -6712, 4010, -4347, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, -3712, 1960, -4647, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 88, 2210, -3847, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, -2212, 2270, 2453, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 2488, -1070, 3053, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 10988, -5890, 3793, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 4188, -2220, 5593, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 2388, 3870, -3107, 0, 0, 0, 0x00000001, id_bhvArenaKoth),
		OBJECT(MODEL_NONE, 28, 2300, -3637, 0, 0, 0, (01 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, -492, -1500, 6733, 0, 0, 0, (01 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, -6132, 7820, 7863, 0, 0, 0, (03 << 24), id_bhvArenaItem),
		OBJECT(MODEL_NONE, 2, -3398, 923, 0, 0, 0, 0x00070000, bhvFadingWarp),
		OBJECT(MODEL_NONE, 4802, -2218, 5593, 0, 0, 0, 0x00080000, bhvFadingWarp),
		OBJECT(MODEL_NONE, 928, -3400, 13, 0, 0, 0, 0x00010000, bhvFadingWarp),
		OBJECT(MODEL_NONE, 2358, 3900, 3613, 0, 0, 0, 0x00020000, bhvFadingWarp),
		OBJECT(MODEL_LLL_TILTING_SQUARE_PLATFORM, 1958, 800, 13, 0, 0, 0, 0x00000000, bhvLllTiltingInvertedPyramid),
		OBJECT(MODEL_LLL_TILTING_SQUARE_PLATFORM, -3522, 1100, -1527, 0, 0, 0, 0x00000000, bhvLllTiltingInvertedPyramid),
		OBJECT(MODEL_LLL_TILTING_SQUARE_PLATFORM, 2758, 800, 13, 0, 0, 0, 0x00000000, bhvLllTiltingInvertedPyramid),
		OBJECT(MODEL_LLL_TILTING_SQUARE_PLATFORM, -3522, 1300, -2427, 0, 0, 0, 0x00000000, bhvLllTiltingInvertedPyramid),
		OBJECT(MODEL_LLL_TILTING_SQUARE_PLATFORM, -3522, 1500, -3327, 0, 0, 0, 0x00000000, bhvLllTiltingInvertedPyramid),
		OBJECT(MODEL_NONE, -947, -3400, 13, 0, 0, 0, 0x00040000, bhvFadingWarp),
		OBJECT(MODEL_NONE, -2247, 2300, 2983, 0, 0, 0, 0x00030000, bhvFadingWarp),
		OBJECT(MODEL_NONE, 0, 1200, -10, 0, 0, 0, 0x000A0000, bhvSpinAirborneWarp),
		MARIO_POS(0x01, 0, 0, 1200, -10),
		OBJECT(MODEL_EXCLAMATION_BOX, 3228, 8300, -3037, 0, 0, 0, 0x00000000, bhvExclamationBox),
		TERRAIN(castle_grounds_area_1_collision),
		MACRO_OBJECTS(castle_grounds_area_1_macro_objs),
		SET_BACKGROUND_MUSIC(0x00, SEQ_LEVEL_KOOPA_ROAD),
		TERRAIN_TYPE(TERRAIN_STONE),
		/* Fast64 begin persistent block [area commands] */
		/* Fast64 end persistent block [area commands] */
	END_AREA(),

	FREE_LEVEL_POOL(),
	MARIO_POS(0x01, 0, 0, 1200, -10),
	CALL(0, lvl_init_or_update),
	CALL_LOOP(1, lvl_init_or_update),
	CLEAR_LEVEL(),
	SLEEP_BEFORE_EXIT(1),
	EXIT(),
};
