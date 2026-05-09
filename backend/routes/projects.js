//
//  Projects Management Routes
//  CRUD operations for architecture projects
//

const express = require('express');
const router = express.Router();
const Joi = require('joi');
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

// Initialize Supabase
const supabase = createClient(
    process.env.SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Validation Schemas
const projectSchema = Joi.object({
    id: Joi.string().uuid().optional(),
    projectName: Joi.string().required().min(1).max(100),
    clientName: Joi.string().optional().max(100),
    location: Joi.string().required().min(1).max(200),
    plotSize: Joi.number().required().min(100).max(100000),
    totalArea: Joi.number().required().min(50).max(10000),
    floors: Joi.number().integer().required().min(1).max(10),
    style: Joi.string().required().valid(
        'Modern Saudi',
        'Traditional Najdi',
        'Mediterranean',
        'Contemporary',
        'Islamic',
        'Luxury Villa',
        'Palace'
    ),
    summary: Joi.object().required(),
    rooms: Joi.array().required(),
    materials: Joi.array().required(),
    budget: Joi.object().required(),
    images: Joi.array().required(),
    timestamp: Joi.date().optional(),
    aiConfidence: Joi.number().optional(),
    processingTime: Joi.number().optional(),
    userId: Joi.string().optional()
});

// GET /api/projects
// Get all projects (with optional filtering)
router.get('/', async (req, res, next) => {
    try {
        const {
            page = 1,
            limit = 20,
            style,
            location,
            search,
            sortBy = 'created_at',
            sortOrder = 'desc'
        } = req.query;

        console.log(`📋 Fetching projects: page=${page}, limit=${limit}, style=${style}, search=${search}`);

        // Build query
        let query = supabase
            .from('projects')
            .select('*');

        // Apply filters
        if (style) {
            query = query.eq('style', style);
        }

        if (location) {
            query = query.ilike('location', `%${location}%`);
        }

        if (search) {
            query = query.or(`project_name.ilike.%${search}%,location.ilike.%${search}%,client_name.ilike.%${search}%`);
        }

        // Apply sorting
        const orderColumn = sortBy === 'created_at' ? 'created_at' : 
                           sortBy === 'project_name' ? 'project_name' : 
                           sortBy === 'total_area' ? 'total_area' : 'created_at';
        
        query = query.order(orderColumn, { ascending: sortOrder === 'asc' });

        // Apply pagination
        const from = (page - 1) * limit;
        const to = from + limit - 1;
        query = query.range(from, to);

        const { data, error, count } = await query;

        if (error) {
            console.error('Supabase query error:', error);
            return next(error);
        }

        // Get total count for pagination
        const { count: totalCount } = await supabase
            .from('projects')
            .select('*', { count: 'exact', head: true });

        res.json({
            success: true,
            data: data || [],
            pagination: {
                page: parseInt(page),
                limit: parseInt(limit),
                total: totalCount || 0,
                totalPages: Math.ceil((totalCount || 0) / limit)
            },
            filters: { style, location, search },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Get projects error:', error);
        next(error);
    }
});

// GET /api/projects/:id
// Get single project by ID
router.get('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;

        if (!id) {
            const error = new Error('Project ID is required');
            error.status = 400;
            return next(error);
        }

        console.log(`🔍 Fetching project: ${id}`);

        const { data, error } = await supabase
            .from('projects')
            .select('*')
            .eq('id', id)
            .single();

        if (error) {
            if (error.code === 'PGRST116') {
                // No rows returned
                return res.status(404).json({
                    success: false,
                    error: 'Project not found',
                    timestamp: new Date().toISOString()
                });
            }
            console.error('Supabase query error:', error);
            return next(error);
        }

        res.json({
            success: true,
            data: data,
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Get project error:', error);
        next(error);
    }
});

// POST /api/projects
// Create new project
router.post('/', async (req, res, next) => {
    try {
        // Validate input
        const { error: validationError, value: validatedValue } = projectSchema.validate(req.body);
        if (validationError) {
            const errorObj = new Error('Validation failed');
            errorObj.name = 'ValidationError';
            errorObj.details = validationError.details;
            return next(errorObj);
        }

        const projectData = {
            ...validatedValue,
            id: require('uuid').v4(),
            timestamp: new Date().toISOString(),
            aiConfidence: validatedValue.aiConfidence || 0.85,
            processingTime: validatedValue.processingTime || 3.0,
            userId: validatedValue.userId || 'anonymous-user'
        };

        console.log(`➕ Creating project: ${projectData.projectName}`);

        const { data: savedData, error: insertError } = await supabase
            .from('projects')
            .insert([projectData])
            .select();

        if (insertError) {
            console.error('Supabase insert error:', insertError);
            return next(insertError);
        }

        console.log(`✅ Project created: ${data[0].id}`);

        res.status(201).json({
            success: true,
            data: data[0],
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Create project error:', error);
        next(error);
    }
});

// PUT /api/projects/:id
// Update existing project
router.put('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;

        if (!id) {
            const error = new Error('Project ID is required');
            error.status = 400;
            return next(error);
        }

        // Validate input
        const { error: validationError, value: validatedValue } = projectSchema.validate(req.body);
        if (validationError) {
            const errorObj = new Error('Validation failed');
            errorObj.name = 'ValidationError';
            errorObj.details = validationError.details;
            return next(errorObj);
        }

        console.log(`📝 Updating project: ${id}`);

        const { data: updatedData, error: updateError } = await supabase
            .from('projects')
            .update({
                ...validatedValue,
                updated_at: new Date().toISOString()
            })
            .eq('id', id)
            .select();

        if (updateError) {
            if (updateError.code === 'PGRST116') {
                return res.status(404).json({
                    success: false,
                    error: 'Project not found',
                    timestamp: new Date().toISOString()
                });
            }
            console.error('Supabase update error:', updateError);
            return next(updateError);
        }

        console.log(`✅ Project updated: ${id}`);

        res.json({
            success: true,
            data: updatedData[0],
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Update project error:', error);
        next(error);
    }
});

// DELETE /api/projects/:id
// Delete project
router.delete('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;

        if (!id) {
            const idError = new Error('Project ID is required');
            idError.status = 400;
            return next(idError);
        }

        console.log(`🗑️ Deleting project: ${id}`);

        const { data, error: deleteError } = await supabase
            .from('projects')
            .delete()
            .eq('id', id);

        if (deleteError) {
            console.error('Supabase delete error:', deleteError);
            return next(deleteError);
        }

        console.log(`✅ Project deleted: ${id}`);

        res.json({
            success: true,
            message: 'Project deleted successfully',
            data: { id },
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Delete project error:', error);
        next(error);
    }
});

// GET /api/projects/stats
// Get project statistics
router.get('/stats', async (req, res, next) => {
    try {
        console.log('📊 Fetching project statistics');

        // Get total count
        const { count: totalCount } = await supabase
            .from('projects')
            .select('*', { count: 'exact', head: true });

        // Get style distribution
        const { data: styleData } = await supabase
            .from('projects')
            .select('style')
            .then(projects => {
                const styleCounts = {};
                projects.forEach(project => {
                    styleCounts[project.style] = (styleCounts[project.style] || 0) + 1;
                });
                return styleCounts;
            });

        // Get average area
        const { data: areaData } = await supabase
            .from('projects')
            .select('total_area');

        const averageArea = areaData && areaData.length > 0 
            ? areaData.reduce((sum, project) => sum + project.total_area, 0) / areaData.length 
            : 0;

        // Get projects this month
        const thisMonth = new Date().toISOString().slice(0, 7); // YYYY-MM
        const { data: monthData } = await supabase
            .from('projects')
            .select('created_at')
            .gte('created_at', thisMonth + '-01');

        const stats = {
            totalProjects: totalCount || 0,
            styleDistribution: styleData || {},
            averageArea: Math.round(averageArea),
            projectsThisMonth: (monthData || []).length,
            mostPopularStyle: getMostPopularStyle(styleData || {}),
            lastUpdated: new Date().toISOString()
        };

        res.json({
            success: true,
            data: stats,
            timestamp: new Date().toISOString()
        });

    } catch (error) {
        console.error('Get stats error:', error);
        next(error);
    }
});

// GET /api/projects/export/:id
// Export project data
router.get('/export/:id', async (req, res, next) => {
    try {
        const { id } = req.params;
        const format = req.query.format || 'json';

        const { data, error } = await supabase
            .from('projects')
            .select('*')
            .eq('id', id)
            .single();

        if (error) {
            if (error.code === 'PGRST116') {
                return res.status(404).json({
                    success: false,
                    error: 'Project not found',
                    timestamp: new Date().toISOString()
                });
            }
            return next(error);
        }

        if (format === 'csv') {
            // Convert to CSV format
            const csv = convertProjectToCSV(data);
            res.setHeader('Content-Type', 'text/csv');
            res.setHeader('Content-Disposition', `attachment; filename="${data.projectName.replace(/\s+/g, '_')}.csv"`);
            res.send(csv);
        } else {
            // Return JSON
            res.json({
                success: true,
                data: data,
                timestamp: new Date().toISOString()
            });
        }

    } catch (error) {
        console.error('Export project error:', error);
        next(error);
    }
});

// Helper Functions
function getMostPopularStyle(styleCounts) {
    let maxCount = 0;
    let mostPopular = null;

    Object.entries(styleCounts).forEach(([style, count]) => {
        if (count > maxCount) {
            maxCount = count;
            mostPopular = style;
        }
    });

    return mostPopular;
}

function convertProjectToCSV(project) {
    const headers = [
        'Project Name',
        'Client Name',
        'Location',
        'Plot Size (m²)',
        'Total Area (m²)',
        'Floors',
        'Style',
        'AI Confidence',
        'Processing Time (s)',
        'Created At'
    ];

    const row = [
        project.projectName,
        project.clientName || '',
        project.location,
        project.plotSize,
        project.totalArea,
        project.floors,
        project.style,
        project.aiConfidence,
        project.processingTime,
        project.timestamp
    ];

    return [headers, row].map(row => row.join(',')).join('\n');
}

module.exports = router;
